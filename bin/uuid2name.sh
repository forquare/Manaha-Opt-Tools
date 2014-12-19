#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

WHITELIST=$SERVER_DIR/whitelist.json
UUID=$1

NAME=`grep -A 1 $UUID $WHITELIST`
if [[ $? != 0  ]]; then
	echo "NOT FOUND"
else
	echo $NAME | sed 's/.*"name": "\(.*\)"/\1/'
fi
