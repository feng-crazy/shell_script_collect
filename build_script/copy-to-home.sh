#!/bin/bash

MACHINE_HOME=/home/edan

printf_help () {
	printf "\n$0 option1 [option2] \n\n"	
	printf "option1:	必须参数，接受参数：v8|im20|im50|im80 \n"
	printf "option2:	可选参数，指定Mx源码的路径，不指定则默认为当前路径\n"
}

print_splitline () {
	printf "\n--------------------------------分割线-----------------------------------------\n"
}

printf_red_bold () {
	printf "\033[31;1m$1\033[0m"
}

printf_green_bold () {
	printf "\033[32;1m$1\033[0m"
}

printf_bold () {
	printf "\033[1m$1\033[0m"
}

print_habbpy_line () {
	printf_green_bold "\n-------^_^--^_^--^_^---------^_^--^_^--^_^---------^_^--^_^--^_^--------------\n"
}

print__angry_line () {
	printf_red_bold "\n------->_<-->_<-->_<--------->_<-->_<-->_<--------->_<-->_<-->_<--------------\n"
}


if [ "$2" == "" ] ; then
	printf_help
	PROJECT_SOURCE_DIR=$PWD
else
	PROJECT_SOURCE_DIR=$2
fi

case "$1" in
	v5|v6|v8|im20|im50|im60|im70|im80)
		MACHINE=$1
		;;
	"--help")	
		printf_help
		;;
	*)
		printf "\n---ERROR: MACHINE is not specified ,use \"$0 option1\" to set MACHINE !\n\n"
		printf_help
		exit 2
		;;
esac


MACHINE_HOME=/home/nfs/edan_$MACHINE
PROJECT_BINARY_DIR=$PROJECT_SOURCE_DIR/build-$MACHINE

if ! [ -d $PROJECT_BINARY_DIR ] ; then
	printf "\n---ERROR:$PROJECT_BINARY_DIR 目录不存在！\n\n"
	exit 3
fi

if ! [ -d  $MACHINE_HOME ] ; then
	sudo mkdir -p $MACHINE_HOME
	sudo chown -R `whoami` $MACHINE_HOME		
fi

printf "PROJECT_SOURCE_DIR =$PROJECT_SOURCE_DIR \n"
printf "PROJECT_BINARY_DIR =$PROJECT_BINARY_DIR \n"
printf "MACHINE TYPE=$MACHINE\n"
printf "MACHINE_HOME=$MACHINE_HOME\n"

svn export --force  $PROJECT_SOURCE_DIR/../Resources/ $MACHINE_HOME

cp $PROJECT_BINARY_DIR/testMx $MACHINE_HOME/bin
cp $MACHINE_HOME/etc/AppConfig-$MACHINE.xml $MACHINE_HOME/etc/AppConfig.xml
sudo chmod a+w $MACHINE_HOME/etc

printf_red_bold "NOTE: Please add $MACHINE_HOME to your own NFS config file (/etc/exports ,etc), if you want to DEBUG on remote machine!\n"
