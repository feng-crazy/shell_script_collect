#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

set -x

sudo cp lt_process /etc/init.d/
sudo chmod 777 /etc/init.d/lt_process
sudo update-rc.d lt_process defaults 99
sudo service lt_process start

