#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

set -x

build_pi_env()
{
	lib_file="/usr/local/lib"
	if [ ! -f "$lib_file/libzmq.so" ]; then
		sudo mkdir -p "$lib_file"
		sudo cp lib/* "$lib_file" -rf
	fi
	rm build -rf
	rm CMakeLists.txt
	cp PI_CMakeLists.txt CMakeLists.txt 
	mkdir build
	cd build
	cmake ../
}

build_host_env()
{
	lib_file="/usr/local/arm/lib"
	if [ ! -f "$lib_file/libzmq.so" ]; then
		sudo mkdir -p "$lib_file"
		sudo cp lib/* "$lib_file" -rf
	fi
	rm build -rf
	rm CMakeLists.txt
	cp PC_CMakeLists.txt CMakeLists.txt 
	mkdir build
	cd build
	cmake ../
}

build_host_gtan()
{
	rm build -rf
	rm CMakeLists.txt
	cp PC_TAN_CMakeLists.txt CMakeLists.txt 
	mkdir build
	cd build
	cmake ../
}

build_help()
{
	echo "input H Use cross-compilation on a PC "
	echo "input R The program compiles on the PI "
}


if [ "$1" = "R" ] ; then
	build_pi_env
	echo "build_pi_env"
elif [ "$1" = "H" ] ; then
	build_host_env
	echo "build_host_env"
elif [ "$1" = "T" ] ; then
	build_host_gtan
	echo "Cross compile on gtan's computer"
else
	build_help
fi



