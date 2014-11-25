#!/bin/bash

DATE=`date +"%Y-%m-%d"`
LOGS="/opt/msm/servers/manaha/logs/latest.log"
CHECK_FILE=/home/manaha-minecrafter/.last_crash

LAST_CRASH=`egrep -a "Server thread/ERROR|Server Watchdog/ERROR" $LOGS | grep crash | sort -n | tac | head -n 1`
if [[ $LAST_CRASH == "" ]]; then
	exit 0;
fi
LAST_CRASH="$DATE $LAST_CRASH"
LAST_REPORTED_CRASH=`cat $CHECK_FILE`

echo $LAST_CRASH
echo $LAST_REPORTED_CRASH

if [ "$LAST_CRASH" == "$LAST_REPORTED_CRASH" ]; then
	echo "No crash detected"
else
	echo "Server crashed"
	echo $LAST_CRASH > $CHECK_FILE
	echo "Restarting server"
	/usr/local/bin/msm manaha stop now
	SCREEN=ps -ef | grep SCREEN | awk '{print $2}'
	while [[ $SCREEN ]]; do
		for EACH in $SCREEN; do
			kill -9 $EACH
		done
		SCREEN=ps -ef | grep SCREEN | awk '{print $2}'
	done
	
fi
