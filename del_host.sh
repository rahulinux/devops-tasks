#!/bin/bash

## Clean up for testing from scratch

for CID in $( docker ps -a  | awk '/redis_|web_|mongodb_|mysql_/ { print $1}' )
do
     CIP=$( docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID} )
     [[ ! -z $CIP ]] && ssh-keygen -f ~/.ssh/known_hosts -R ${CIP}
     docker rm -f $CID
done
