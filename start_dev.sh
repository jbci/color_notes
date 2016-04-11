#!/bin/sh
#sudo service postgresql status
output="$(sudo service postgresql status |grep online)" 
if [ X"$output" = X"" ]; then
  echo "launching database"
  sudo service postgresql start
fi
output="$(sudo service redis-server status |grep not)" 
if [ X"$output" != X"" ]; then
  echo "launching redis server"
  sudo service redis-server start
fi
rails s -b $IP -p $PORT