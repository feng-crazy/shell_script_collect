#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

export LANG=en_US.utf8

#解决一些权限问题
sudo chown pi:pi /home/LT -R
sudo chmod 777 /home/LT -R
cd /home/LT/Bin

#set -x

lt_kill()
{
	sudo killall -9 terminal.py
	sudo killall -9 DataHub 
	sudo killall -9 LocEngine
}

lt_restart()
{ 
	lt_kill
	./terminal.py > /dev/null &
}



lt_help()
{ 
	echo "Please enter 'start' to start lingtrack's program."
	echo "Please enter 'kill' to kill lingtrack's program."
	echo "Please enter 'restart' to restart lingtrack's program."
}


case "$1" in
	start)
		./terminal.py > /dev/null &
	;;
	kill)
		lt_kill
	;;
	restart)
		lt_restart 
	;;
	*)
		lt_help
		exit 1
	;;
esac



