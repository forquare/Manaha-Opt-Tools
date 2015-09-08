#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

AUTO_REBOOT="auto_reboot"
NIGHTLY_MAINT="nightly_maintenance"
KEEP_ALIVE="keep_alive"

cd $MAINTENANCE_LOGS_DIR

IFS="
"

# Remove logs that didn't have a crash
for EACH in `ls | grep $AUTO_REBOOT`; do
	log=`<$EACH`
	if [ "$log" == "No crash detected" ]; then
		rm $EACH
	fi
done

# Remove logs files older than 30 days
find $MAINTENANCE_LOGS_DIR -mtime +30 -print0 | xargs -0 rm
find $MAINTENANCE_LOGS_DIR -iname "$KEEP_ALIVE*" -mmin +360 -print0 | xargs -0 rm

gunzip $SERVER_LOGS_DIR/*.gz
