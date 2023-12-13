Following project is exceuting in linux machine ubuntu. Python 3.6.9 is required. -
Clone the main github repo on local machine 
main github "https://github.com/NUStreaming/BoB.git"
Forked github "https://github.com/cbadguj/BoB.git"
After cloning

Modify the Directory:
cd BoB: Navigate to the directory "BoB."

Image of a Docker:
docker pull sudo Download a Docker image from the provided repository using opennetlab.azurecr.io/challenge-env.

Files to be downloaded:
wget https://raw.githubusercontent.com/OpenNetLab/AlphaRTC/main/examples/peerconnection/serverless/corpus/receiver_pyinfer.json -O receiver_pyinfer.json: Download a JSON file and save it as "receiver_pyinfer.json."
wget -O sender_pyinfer.json https://raw.githubusercontent.com/OpenNetLab/AlphaRTC/main/examples/peerconnection/serverless/corpus/sender_pyinfer.json Download and save another JSON file as "sender_pyinfer.json."

Make a Directory:
make testmedia: Make a folder called "testmedia."

Download the following media files:
wget -O testmedia/test.wav https://github.com/OpenNetLab/AlphaRTC/raw/main/examples/peerconnection/serverless/corpus/testmedia/test.wav: Download and save an audio file to the "testmedia" directory.
wget https://raw.githubusercontent.com/OpenNetLab/AlphaRTC/main/examples/peerconnection/serverless/corpus/testmedia/test.yuv Download and save a video file to the "testmedia" directory.

Start the Docker Container:
Connection of local machine and docker container can be made through this command 
sudo docker run -d --rm -v `pwd`:/app -w /app --name alphartc_pyinfer opennetlab.azurecr.io/challenge-env peerconnection_serverless receiver_pyinfer.json
docker run -d --rm -v pwd:/app -w /app alphartc_pyinfer Start a Docker container named opennetlab.azurecr.io/challenge-env peerconnection_serverless receiver_pyinfer.json.
docker run -d --rm -v pwd:/app -w /app alphartc_pyinfer opennetlab.azurecr.io/challenge-env json file peerconnection_serverless receiver_pyinfer: Start a Docker container named "alphartc_pyinfer" with the supplied specifications, running a peer connection server with the configuration "receiver_pyinfer.json".

Docker Containers List:
Vefify container is created:
docker run ps -a:

Script execution in a Docker container:
sudo docker exec alphartc_pyinfer peerconnection_serverless sender_pyinfer.json: Run a script named "sender_pyinfer.json" inside the Docker container that is currently executing.

Modify the Directory:
Navigate to the directory "environment."
cd environment: 

Environment for Construction:
 Use the "make" command to create the environment.
sudo make all:

Using Up Directories:
cd ..: Go up one directory level.

Run the following script with Traffic Control (TC):
sudo./run_with_tc.sh: Run a script with superuser privileges named "run_with_tc.sh" that may entail network traffic control.


Following bellow are some troubleshooting steps included to run file if above command doesn't work. 



Check out Bash.

Version of Bash:



bash --version: Displays the Bash shell's version.

Display Script Details:



./run_with_tc.sh head -n 1: Display the first line of the "run_with_tc.sh" script.

ls -l./run_with_tc.sh: Returns extensive information on the "run_with_tc.sh" script.

./run_with_tc.sh bash -n: Without running the "run_with_tc.sh" script, examine its syntax.

bash -x./run_with_tc.sh: Run the script "run_with_tc.sh" with debugging information.

Check out the Superuser Bash Version:



sudo bash --version: Displays the Bash shell version with superuser access.

sudo head -n 1./run_with_tc.sh: Display the first line of the "run_with_tc.sh" script as a superuser.

sudo ls -l./run_with_tc.sh: With superuser capabilities, display extensive information about the "run_with_tc.sh" script.

./run_with_tc.sh sudo bash: Without executing it, examine the syntax of the "run_with_tc.sh" script with superuser capabilities.

./run_with_tc.sh sudo bash: Without executing it, examine the syntax of the "run_with_tc.sh" script with superuser capabilities.

sudo bash -x./run_with_tc.sh: Run the "run_with_tc.sh" script as a superuser with debugging information.

