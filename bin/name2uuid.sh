#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

WHITELIST=$SERVER_DIR/whitelist.json
NAME=$1

UUID=`grep -B 1 $NAME $WHITELIST`
if [[ $? != 0  ]]; then
	echo "NOT FOUND"
else
	# Capture goup of 8-4-4-4-12
	echo $UUID | sed 's/.*\([a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}\).*/\1/'
fi
