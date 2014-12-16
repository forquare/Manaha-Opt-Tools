#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

MAP_STATUS=`du -sh $HTTP_MAP/ | sed 's/\(^....\).*/\1/g'`

ps -ef | grep -v grep | grep overviewer > /dev/null
if [[ $? == 0 ]]; then
	exit 0;
fi

if [[ $MAP_STATUS != "4.0K" ]]; then
	nice -n 20 $BIN_DIR/map_gen.sh
fi
