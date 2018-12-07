#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

export LANG=en_US.utf8

#set -x

export PATH=/home/LT/Bin:$PATH

#解决一些权限问题
sudo chown pi:pi /home/LT -R
sudo chmod 777 /home/LT -R
cd /home/LT/Bin

CONFIG_FILE="config.txt"
if [ ! -f "$CONFIG_FILE" ]; then
	cp config_template.txt "$CONFIG_FILE"
fi

LOG_FILE="$PWD/../Data/error.log"

CONFIG_FILE_VERSION="lth_config_version.txt"

First="`md5sum $PWD/config.txt | awk '{print $1}'`"


#./DataHub -c config.txt > /dev/null &

printf "\nlt_daemon start at $(date +'%Y-%m-%d %H:%M:%S')\n" >> $LOG_FILE

while true; do
	
	ps_ret=`ps -fe | grep DataHub |grep -v grep`
	if [ $? -ne 0 ]
	then
		echo "DataHub is not exist start DataHub\n" >> $LOG_FILE
		printf "DataHub start at $(date +'%Y-%m-%d %H:%M:%S')\n" >> $LOG_FILE
		./DataHub -c config.txt &#> /dev/null &
	fi
	
	ps_ret=`ps -fe | grep LocEngine |grep -v grep`
	if [ $? -ne 0 ]
	then
		echo "LocEngine is not exist start LocEngine\n" >> $LOG_FILE
		printf "LocEngine start at $(date +'%Y-%m-%d %H:%M:%S')\n" >> $LOG_FILE
		version_type=`cat version_info | grep single`
		if [ $? -ne 0 ]
		then
			./LocEngine -c config.txt > /dev/null &
		else
			./LocEngine -c config.txt -s > /dev/null &
		fi
	fi
	
	
	sleep 1
	Second="`md5sum $PWD/config.txt | awk '{print $1}'`"
	 
	if [ "$First" != "$Second" ]
	then
		echo "config change Restart LTHUB and LocEngine\n" >> $LOG_FILE
		printf "LT died at $(date +'%Y-%m-%d %H:%M:%S')\n" >> $LOG_FILE
		printf "$Second" > $CONFIG_FILE_VERSION
		killall -9 LocEngine
		killall -9 DataHub
		First=$Second
	fi
	
	sleep 1
	var=`sed -n '$=' $LOG_FILE`
	if [ $var -gt 5000 ]
	then
		sed -i '1d' $LOG_FILE
	fi
	
	sleep 1
done

