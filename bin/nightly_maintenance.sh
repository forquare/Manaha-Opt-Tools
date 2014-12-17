#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

$MSM $SERVER say "The server is going down for a restart. It will be back up after 1 minute.  10 second countdown"
sleep 5
$MSM $SERVER say "The server is going down for a restart in 10 seconds."

echo "Restarting server"
$MSM $SERVER say "The server is going down for a restart NOW. Back up soon"
$MSM $SERVER stop

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

$MSM $SERVER start	

echo "Generating map"
$BIN_DIR/map_gen.sh
