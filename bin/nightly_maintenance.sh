#!/bin/bash

BIN=/home/manaha-minecrafter/opt/bin
MSM=/usr/local/bin/msm


$MSM manaha say "The server is going down for a restart. It will be back up after 1 minute.  10 second countdown"
sleep 5
$MSM manaha say "The server is going down for a restart in 10 seconds."

echo "Restarting server"
$MSM manaha say "The server is going down for a restart NOW. Back up soon"
$MSM manaha stop

sleep 30

SCREEN=`ps -ef | grep SCREEN | grep -v grep | awk '{print $2}'`
while [[ $SCREEN ]]; do
	for EACH in $SCREEN; do
		kill -9 $EACH
	done
	SCREEN=`ps -ef | grep SCREEN | awk '{print $2}'`
done
screen -wipe
JAVA=`ps -ef | grep server.jar | grep -v grep | awk '{print $2}'`
while [[ $JAVA ]]; do
	for EACH in $JAVA; do
		kill -9 $EACH
	done
	JAVA=`ps -ef | grep server.jar | grep -v grep | awk '{print $2}'`
done

sleep 30

$MSM manaha start	

if [ -f /home/manaha-minecrafter/.forcemap ]; then
	rm -rf /home/manaha-minecrafter/public_html/map/*
	rm -rf /home/manaha-minecrafter/.forcemap
fi
echo "Generating map"
$BIN/map_gen.sh
