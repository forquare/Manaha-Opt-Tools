#!/bin/bash

BIN=/home/manaha-minecrafter/opt/bin

MAP_STATUS=`du -sh /home/manaha-minecrafter/public_html/map/ | sed 's/\(^....\).*/\1/g'`

ps -ef | grep -v grep | grep overviewer > /dev/null
if [[ $? == 0 ]]; then
	exit 0;
fi

if [[ $MAP_STATUS != "4.0K" ]]; then
	nice -n 20 $BIN/map_gen.sh
fi
