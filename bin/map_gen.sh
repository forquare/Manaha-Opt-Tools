#!/bin/bash

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

WORLD=$SERVER_WORLD_DIR

if [ -f $VAR_DIR/.poiChange ]; then
	echo "Generating POIs"
	overviewer.py --config $MAP_CONFIG_FILE --genpoi
	rm $VAR_DIR/.poiChange
fi

echo "Generating map"
overviewer.py --config $MAP_CONFIG_FILE

echo "Chmodding"
chmod -R 755 $HTTP_MAP
