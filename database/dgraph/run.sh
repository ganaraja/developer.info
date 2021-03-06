#!/bin/bash

DATE=`date +%Y-%m-%d`
DATE_TIME=`date '+%Y-%m-%d %H:%M:%S'`

# Contanier details at https://hub.docker.com/_/mysql

export containerName=dgraph
export hostAddress=127.0.0.1
export hostPort=5080
export WEB_ADDR="http://${hostAddress}:${hostPort}"
export ROOT_USERNAME=root
export ROOT_PASSWORD=my-secret-pw


printf "\n -------- Downloading container: ${containerName} -------- \n "  
docker pull ${containerName}/${containerName}:latest &


sleep 15
printf "\n -------- Starting container: ${containerName}  -------- \n"
mkdir ./graphData  # directory where data should be stored.
#docker run -d --name ${containerName} -e MYSQL_ROOT_PASSWORD=${ROOT_PASSWORD} -v ~/TOOLS/mysql/mysql_data:/var/lib/mysql ${containerName} &
docker run --name ${containerName} -it -p ${hostPort}:${hostPort} -p 6080:6080 -v ./graphData:/dgraph ${containerName}/${containerName}:latest dgraph zero --my=${hostAddress}:${hostPort} &

sleep 15

printf '\n\n -------- Container information -------- \n'
printf "\n\n%s\n" " -------- Container information -------- "
containerId=$(docker container ls -a | grep ${containerName} | awk '{print $1}')
#members=$(docker exec -t ${containerName} members)
processId=$(lsof -nP -iTCP:${hostPort}); 
#processId=`lsof -nP -iTCP:5984`
printf "\n%s\n" " Current DT: $DATE_TIME"
printf "\n%s\n" " Container name: ${containerName}"
printf "\n%s\n" " Container id: ${containerId}"
printf "\n%s\n" " Process id: ${processId}"
printf "\n\n"

sleep 2
docker logs -f $containerId &

sleep 15
#open -a 'Google Chrome' $WEB_ADDR
exit 0
