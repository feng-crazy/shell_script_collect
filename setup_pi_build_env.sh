#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#

set -x

buil1_pi_env()
{
	echo "安装编译环境"
	sudo apt-get install libtool
	sudo apt-get install autoconf automake
	
	
	echo "安装telnet"

	sudo apt-get install openbsd-inetd
	sudo apt-get install telnetd

	sudo apt-get install samba samba-common
	sudo mkdir ~/share
	sudo chmod 777 ~/share
	sudo echo "security = user" >> /etc/samba/smb.conf
	sudo echo "[share]
	path = ~/share
	public = yes
	writable = yes
	valid users = pi
	create mask = 0644
	force create mode = 0644
	directory mask = 0755
	force directory mode = 0755
	available = yes" >> /etc/samba/smb.conf
	sudo smbpasswd -a pi



	echo "安装成功!"
}

buil1_host_env()
{
	echo "安装编译环境"
	sudo apt-get install libtool
	sudo apt-get install autoconf automake
	
	sudo apt-get install nfs-kernel-server nfs-common
	sudo mkdir /home/pi
	sudo mkdir /home/pi/nfs_share
	sudo chmod 777 /home/pi -R
	sudo echo "/home/pi/nfs_share *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
	sudo /etc/init.d/rpcbind restart
	sudo /etc/init.d/nfs-kernel-server restart
	
	echo "安装成功!"
}

printf_bold () {
	printf "\033[1m$1\033[0m"
}

build_help(){
  printf_bold "OPTIONS:\n"
  printf_bold "        -p:build pi env \n"
  printf_bold "        -h:build host env \n"	
						
}

#获取命令行传递进来的参数
while getopts ":p:h" opt
do
	case $opt in 
		p) 
				buil1_pi_env
		;;
		h)
		    	buil1_host_env()
		;;
		*)
		     build_help
		     exit 2
		;;
	esac
done