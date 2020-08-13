#!/bin/bash

set -f
string=$DEPLOY_SERVERS
array=(${string//,/ })

for i in "${!array[@]}"; do
 echo "Deploy project on server ${array[i]}"
 ssh ubuntu@${array[i]} "forever stopall && cd dodamshindam/backend && git checkout develop && git pull && pip3 install -r requirements.txt &&nohup python3 app.py &"
done