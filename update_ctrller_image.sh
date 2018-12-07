#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#
set -x


#sudo apt-get install dosfstools dump parted kpartx rsync 

workdir=`pwd`

sudo losetup /dev/loop0 lt_controller.img

mkdir -p img_temp/boot/
mkdir -p img_temp/root/
sudo kpartx -av /dev/loop0 

sleep 3

#loop0p1、loop0p2根据实际情况修改
boot="/dev/mapper/loop0p1"
root="/dev/mapper/loop0p2"
sudo mount $boot img_temp/boot/
sudo mount $root img_temp/root/

cd img_temp/root/home/LT/Bin/LTController

cp /mnt/hgfs/linux_share/code/python/LTController/basestation . -rf 
cp /mnt/hgfs/linux_share/code/python/LTController/terminal . -rf 
cp /mnt/hgfs/linux_share/code/python/LTController/eventbus . -rf 
cp /mnt/hgfs/linux_share/code/python/LTController/utility . -rf 

cp /mnt/hgfs/linux_share/code/python/LTController/ControllerBroadcast.py . -f 
cp /mnt/hgfs/linux_share/code/python/LTController/MainController.py . -f 
cp /mnt/hgfs/linux_share/code/python/LTController/ManagerDevice.py . -f 

exit 0

sudo umount img_temp/boot
sudo umount img_temp/root

sudo kpartx -d /dev/loop0
sudo losetup -d /dev/loop0

sudo rm -rf img_temp
