#!/bin/bash

WORLD=/opt/msm/servers/manaha/world
MAP=/home/manaha-minecrafter/public_html/map

CONFIG=/home/manaha-minecrafter/configs/manaha_map_config.conf

if [ -f /home/manaha-minecrafter/.poiChange ]; then
	echo "Generating POIs"
	overviewer.py --config $CONFIG --genpoi
	rm /home/manaha-minecrafter/.poiChange
fi

echo "Generating map"
overviewer.py --config $CONFIG

echo "Chmodding"
chmod -R 755 $MAP
