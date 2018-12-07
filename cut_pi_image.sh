#!/bin/sh
#===========================================================#
#	AUTHOR：hdf 
#	DATE  ：2017-12-04
#===========================================================#
set -x


#sudo apt-get install dosfstools dump parted kpartx rsync 

workdir=`pwd`

sudo losetup /dev/loop0 2018-04-18-raspbian-stretch.img

mkdir -p img_temp/boot/
mkdir -p img_temp/root/
sudo kpartx -av /dev/loop0 

sleep 3

#loop0p1、loop0p2根据实际情况修改
boot="/dev/mapper/loop0p1"
root="/dev/mapper/loop0p2"
sudo mount $boot img_temp/boot/
sudo mount $root img_temp/root/

#dfsz为镜像实际大小
bootsz=`df -P | grep /dev/mapper/loop0p1 | awk '{print $2}'`
#rootsz=`df -P | grep /dev/mapper/loop0p2 | awk '{print $3}'`
#dfsz=`echo $rootsz $bootsz|awk '{print int($1*1.2+$2)}'`
rootsz=`df -P | grep /dev/mapper/loop0p2 | awk '{print $2}'`
dfsz=`echo $rootsz $bootsz|awk '{print int($1+$2)}'`
echo $bootsz $rootsz $multipe $dfsz
exit 0

boot_start=`sudo fdisk -l | grep /dev/loop0p1 | awk 'NR==1 {print $2}'`
boot_end=`sudo fdisk -l | grep /dev/loop0p1 | awk 'NR==1 {print $3}'`
root_start=`sudo fdisk -l | grep /dev/loop0p2 | awk 'NR==1 {print $2}'`

boot_start=`echo $boot_start's'`
boot_end=`echo $boot_end's'`
root_start=`echo $root_start's'`
echo $boot_start $boot_end $root_start

sudo dd if=/dev/zero of=raspberrypi.img bs=1K count=$dfsz


sudo parted raspberrypi.img --script -- mklabel msdos
sudo parted raspberrypi.img --script -- mkpart primary fat32 $boot_start $boot_end
sudo parted raspberrypi.img --script -- mkpart primary ext4 $root_start -1


loopdevice=`sudo losetup -f --show raspberrypi.img`
echo $loopdevice
device=`sudo kpartx -va $loopdevice | sed -E 's/.*(loop[1-9])p.*/\1/g' | head -1`
echo $device
sleep 5

device="/dev/mapper/${device}"
echo $device
read key
partBoot="${device}p1"
partRoot="${device}p2"
sudo mkfs.vfat $partBoot
sudo mkfs.ext4 $partRoot

sudo mount -t vfat $partBoot /media
sudo cp -rfp img_temp/boot/* /media/

read key

sudo umount /media

sudo mount -t ext4 $partRoot /media/
#cd /media
read key

sudo rsync -aP img_temp/root/ /media/
#--force -rltWDEgop --delete --stats --progress

#sudo chattr +d raspberrypi.img
#sudo chattr +d ./lost+found
#sudo dump -h 0 -0uaf - $root | sudo restore -rf -
#cd $workdir
sudo umount /media


sudo kpartx -d $loopdevice
sudo losetup -d $loopdevice

sudo umount img_temp/boot
sudo umount img_temp/root

sudo kpartx -d /dev/loop0
sudo losetup -d /dev/loop0

sudo rm -rf img_temp
