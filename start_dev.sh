#!/bin/sh
#sudo service postgresql status
sudo service postgresql start
sudo service redis-server start
cd notes
rails s -b $IP -p $PORT