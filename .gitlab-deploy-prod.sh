#!/bin/bash

set -f
string=$DEPLOY_SERVERS
array=(${string//,/ })

for i in "${!array[@]}"; do
 echo "Deploy project on server ${array[i]}"
 ssh ec2-user@${array[i]} "forever stopall && cd dodamshindam/backend && git checkout develop && git pull && nohup python3 app.py &"
done