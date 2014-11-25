#!/bin/bash

WHITELIST=/opt/msm/servers/manaha/whitelist.json
UUID=$1

NAME=`grep -A 1 $UUID $WHITELIST`
if [[ $? != 0  ]]; then
	echo "NOT FOUND"
else
	echo $NAME | sed 's/.*"name": "\(.*\)"/\1/'
fi
