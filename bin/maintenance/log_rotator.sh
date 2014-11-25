#!/bin/bash

LOGS_HOME=/home/manaha-minecrafter/maintenance_logs

AUTO_REBOOT="auto_reboot"
NIGHTLY_MAINT="nightly_maintenance"
KEEP_ALIVE="keep_alive"

cd $LOGS_HOME

IFS="
"

# Remove logs that didn't have a crash
for EACH in `ls | grep $AUTO_REBOOT`; do
	log=`cat $EACH`
	if [ "$log" == "No crash detected" ]; then
		rm $EACH
	fi
done

# Remove logs files older than 30 days
find $LOGS_HOME -mtime +30 -print0 | xargs -0 rm
find ./ -iname "$KEEP_ALIVE*" -mmin +360 -print0 | xargs -0 rm

gunzip /opt/msm/servers/manaha/logs/*.gz
