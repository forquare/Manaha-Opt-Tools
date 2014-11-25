#!/bin/bash

echo "are you alive?" >> /opt/msm/servers/manaha/logs/latest.log
sleep 10
if [ -f /tmp/.allok ]; then
	rm /tmp/.allok
else
	/usr/bin/perl /home/manaha-minecrafter/opt/log_monitor.pl
fi
