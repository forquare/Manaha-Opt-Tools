#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

echo "are you alive?" >> $SERVER_LOGS
sleep 10
if [ -f /tmp/.allok ]; then
	rm /tmp/.allok
else
	$PERL $OPT_DIR/log_monitor.pl
fi
