#!/bin/sh
#/etc/init.d/lt_process

#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

#set -x

#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/home/LT/Bin
#LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:/home/LT/lib
#HOME=/home/LT


case "$1" in
	start)
		echo "Starting lt_daemon.sh" >> /home/LT/Data/error.log
		/home/LT/Bin/lt start &
	;;
	stop)
		echo "Stop lt_daemon.sh" >> /home/LT/Data/error.log
		/home/LT/Bin/lt kill &
	;;

	*)
		echo "Usage: service start_tool start|stop"
		exit 1
	;;
esac
exit 0

