#!/bin/bash

IFS="
"

# Load variables
source /home/manaha-minecrafter/configs/common_variables.conf

PLAYERS=`ls $SERVER_DIR/world/playerdata | sed 's/.dat//g'`
LOGS=`ls $SERVER_LOGS_DIR/*`

ONLINE=""
OFFLINE=""

NL=$'\n'

TEMP=/tmp/$$.players_activity
GREP_STRING=""

for PLAYER in $PLAYERS; do
	PLAYER=`$BIN_DIR/uuid2name.sh $PLAYER`

	ON=`cat $SERVER_DIR/logs/latest.log | grep -a $PLAYER | grep -a "logged in" | wc -l`
	OFF=`cat $SERVER_DIR/logs/latest.log | grep -a $PLAYER | grep -a "lost connection" | wc -l`
	if [[ -f $TEMP ]]; then
		rm $TEMP
		touch $TEMP
	fi

	if [[ $ON > $OFF ]]; then
		ONLINE="$ONLINE${NL}$PLAYER"
	else
		GREP_STRING="$GREP_STRING|$PLAYER"
	fi
done

# Tidy up string beginning
GREP_STRING=`echo $GREP_STRING | sed 's/^|//'`

for LOG in $LOGS; do
	DATE=`echo $LOG | sed 's/\(.*\)\/\([^/]*\)/\2/' | sed 's/\(....-..-..\).*log/\1/g'`
	for EACH in `cat $LOG | grep -aE $GREP_STRING | grep -a "lost connection"`; do
		echo "$DATE $EACH" >> $TEMP
	done
done

DATE=`date "+%Y-%m-%d"`
if [[ `grep -aE  $GREP_STRING $SERVER_DIR/logs/latest.log` ]]; then
	for EACH in `cat $SERVER_DIR/logs/latest.log | grep -aE $GREP_STRING | grep -a 'lost connection'`; do
		echo "$DATE $EACH" >> $TEMP
	done
fi

IFS=" "
for OFFLINE_PLAYER in `echo $GREP_STRING | sed 's/|/ /g'`; do
		OFFLINE="$OFFLINE${NL}`cat $TEMP | grep $OFFLINE_PLAYER | sort | tail -1 | sed 's/\[//g' | sed 's/\]//g' | awk '{print $1, $2}'` $OFFLINE_PLAYER"
		OFFLINE=`echo "$OFFLINE" | sort -r`
done
IFS="
"

if [ "$1" == "web" ]; then
	echo "<table border='1' bgcolor='DimGrey' cellpadding='5'>" 
	for PLAYER in `echo "$ONLINE" | grep -a -e "^$" -v`; do
		echo "<tr bgcolor='LimeGreen'>"
		echo "<td>$PLAYER</td><td><b>ACTIVE NOW!</b></td>"
		echo "</tr>"
	done

	for PLAYER in `echo "$OFFLINE" | grep -a -e "^$" -v`; do
		NAME=`echo $PLAYER | awk '{print $3}'`
		DATE=`echo $PLAYER | awk '{print $1, $2}'`
		echo "<tr bgcolor='red'>"
		echo "<td>$NAME</td><td>`date -d \"$DATE\" +\"%H:%M\"`&nbsp;&nbsp;&nbsp;&nbsp;`date -d \"$DATE\" +\"%d %b %Y\"`</td>"
		echo "</tr>"
	done
	echo "</table>"
else
	for PLAYER in `echo "$ONLINE" | grep -a -e "^$" -v`; do
		echo -e "$PLAYER \t ACTIVE NOW!"
	done

	for PLAYER in `echo "$OFFLINE" | grep -a -e "^$" -v`; do
		NAME=`echo $PLAYER | awk '{print $3}'`
		DATE=`echo $PLAYER | awk '{print $1, $2}'`
		echo -e "$NAME \t\t\t\t `date -d \"$DATE\" +\"%k:%M %d %b %Y\"`"
	done

fi


rm $TEMP
