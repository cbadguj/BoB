#!/bin/bash

# Get the current date and time
date=$(date '+%d_%m_%Y_%H%M')

# Directories and filenames
MODELDIR="./model"
RESULTDIR="results_${date}"
EVAL_LOGFILE="eval.log"
rm -rf ${EVAL_LOGFILE}

# Function to run tests for a given model
runTestsOnModel() {
  modelName=$1
  resultsDir=$2

  # List of profiles to test
  profiles=("lte_profile_x0.25" "cascade_profile_x0.25" "twitch_profile_x0.25" "FCCamazone_x0.25" "Synthtic_x0.25")

  for PROFILE in "${profiles[@]}"
  do
    for ((runIndex=1;runIndex<=5;runIndex++)); 
    do
      # Clear the logs
      rm -rf webrtc.log
      rm -rf bandwidth_estimator.log
      rm -rf plot.png

      # Set active model
      MODEL="${MODELDIR}/${modelName}"
      echo $MODEL > active_model

      # Run Docker containers
      docker run -d --rm -v `pwd`:/app -w /app --name alphartc_pyinfer --cap-add=NET_ADMIN challenge-env peerconnection_serverless receiver_pyinfer.json
      sleep 1
      docker exec -d -w /app/tc_profiles alphartc_pyinfer bash ./tc_policy.sh $PROFILE
      docker exec alphartc_pyinfer peerconnection_serverless sender_pyinfer.json

      # Calculate average bandwidth
      averageBW=$(python3 calculateAverageBandwidth.py --network_profile tc_profiles/${PROFILE} | sed 's/averageBandwidth: \(.*\)/\1/')

      # Run evaluation and plotting scripts
      bash ./eval.sh $averageBW
      python3 plot.py --title $PROFILE
      mv plot.png $resultsDir/plot_${modelName}_${PROFILE}_${runIndex}.png
      python3 log_eval.py --model ${modelName} --network_profile ${PROFILE} --eval_log_file ${EVAL_LOGFILE}

      # Move evaluation results to the result directory
      mv out_eval_video.json ${resultsDir}/out_eval_video_${modelName}_${PROFILE}_${runIndex}.json
      mv out_eval_network.json ${resultsDir}/out_eval_network_${modelName}_${PROFILE}_${runIndex}.json
      mv bandwidth_estimator.log ${resultsDir}/bandwidth_estimator_${modelName}_${PROFILE}_${runIndex}.log
      mv outvideo.yuv ${resultsDir}/outputvideo_${modelName}_${PROFILE}_${runIndex}.yuv
      mv outaudio.wav ${resultsDir}/outaudio_${modelName}_${PROFILE}_${runIndex}.wav
    done
  done
}

# Run tests for each model
modelResultDir=${RESULTDIR}_bob
rm -rf $modelResultDir
mkdir -p $modelResultDir
cp BandwidthEstimator_bob.py BandwidthEstimator.py
runTestsOnModel "bob_2022_02_23.pth" $modelResultDir
mv ${EVAL_LOGFILE} $modelResultDir/

modelResultDir=${RESULTDIR}_gemini
rm -rf $modelResultDir
mkdir -p $modelResultDir
cp BandwidthEstimator_gemini.py BandwidthEstimator.py
runTestsOnModel "ppo_gemini_2021_07_20_09_15_37.pth" $modelResultDir
mv ${EVAL_LOGFILE} $modelResultDir/

modelResultDir=${RESULTDIR}_hrcc
rm -rf $modelResultDir
mkdir -p $modelResultDir
cp BandwidthEstimator_hrcc.py BandwidthEstimator.py
runTestsOnModel "ppo_hrcc_final.pth" $modelResultDir
mv ${EVAL_LOGFILE} $modelResultDir/

modelResultDir=${RESULTDIR}_bob_heuristic
rm -rf $modelResultDir
mkdir -p $modelResultDir
cp BandwidthEstimator_bob_heuristic.py BandwidthEstimator.py
runTestsOnModel "bob_heuristic" $modelResultDir
mv ${EVAL_LOGFILE} $modelResultDir/

