#!/bin/bash
############################################################################
#	  COPYRIGHT: 2009 Edan Instruments, Inc. All rights reserved
#	PROJECTNAME: Mx
#		VERSION:
#	   FILENAME: build-image.sh
#		CREATED: 2012.07.26
#		 AUTHOR: 张虎
#	DESCRIPTION: 配置Mx
############################################################################
export LANG=en_US.utf8
project_svn_path="http://192.168.1.19/svn/2707I"
project_source_path=$(pwd)
mx_release_svn=`svn info $project_source_path | grep "^URL: " | sed 's/URL: //g' | sed 's/src//g'`
mx_resources_svn="$mx_release_svn/Resources"

need_refresh="no"
os_separate="no"
machine=""
platform=""
target_dir=""

project_revision=r`svn info $mx_release_svn | grep "^Last Changed Rev:"| sed 's/Last Changed Rev: //g'`
echo "project_revision = $project_revision"
build_time=`date  +%Y%m%d%H%M`

MxTarget_dir=$project_source_path/MxTarget
zipfile_dir=$MxTarget_dir/$project_revision

alias cp='cp -v'

etc_file_list="SysConfig.xml MdlConfig.xml UIConfig.xml MxConfig.xml"

locale_file_list="BulgarianPrt.xml           Croatian.xml    FrancePrt.xml     Hungarian.xml    PolishPrt.xml            Romanian.xml     TurkishPrt.xml
Bulgarian.xml              CzechPrt.xml    France.xml        ItalianPrt.xml   Polish.xml               RussianPrt.xml   Turkish.xml
ChineseSimplifiedPrt.xml   Czech.xml       GermanyPrt.xml    Italian.xml      PortugueseBrazilPrt.xml  Russian.xml      VietnamesePrt.xml
ChineseSimplified.xml      DutchPrt.xml    Germany.xml       PortugueseBrazil.xml   Vietnamese.xml
ChineseTraditionalPrt.xml  Dutch.xml       GreekPrt.xml
ChineseTraditional.xml     EnglishPrt.xml  Greek.xml         SpanlishPrt.xml
CroatianPrt.xml            English.xml     HungarianPrt.xml  RomanianPrt.xml          Spanlish.xml"


soud_file_list="heart_beep.wav  hi_lev.wav  key.wav  lo_lev.wav  med_lev.wav"

pulse_tone_file_list="300.wav  350.wav  400.wav  500.wav  600.wav  800.wav  1000.wav  1300.wav  1500.wav"

font_file_list1="fonts.dir universcondensed.ttf  verdanab.ttf  verdana.ttf"
font_file_list2="fonts.dir universcondensed.ttf  verdanab.ttf  verdana.ttf"

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


check_file()
{
	local file_path=$1
	local file_name=$2

	printf "checking $file_path/$file_name ..."	

	if ! [ -f $file_path/$file_name ] ; then
		# 红色字体并加粗输出错误信息
		printf_red_bold "\t\t[not found] \n"
		print__angry_line
		printf_red_bold "\n[ERROR] : $file_path/$file_name NOT exist !\n\n"
		exit
	fi
	printf "\t\t\033[32;1m[found]\033[0m "
	# 如果是压缩包，则根据package_name.tar.bz2/gz的规则解出package_name,否则直接导出源码。
	if  echo $file_name | grep ".xml" &> /dev/null ; then
		printf "\t checking XML format..."
		if ! xmllint $file_path/$file_name 1>/dev/null 2> ./checkfiles.log ; then
			# 红色字体并加粗输出错误信息
			printf_red_bold "\t\t[fail]\n"
			print__angry_line
			printf_red_bold "\n[ERROR] : $file_path/$file_name format error !\n\n"
			printf_bold "[SUMMARY]:\n"
			cat ./checkfiles.log
			exit
		fi
		printf "\t\t\033[32;1m[ok]\033[0m"
	fi
	
	printf "\n"
	
}

check_files()
{
	local file_path=$1
	local file_list=$2

	for file_name in $file_list ; do
		check_file $file_path $file_name
	done
}

export_resource()
{
	if [ "$need_refresh" == "refresh" ] ; then
		#导出根文件系统。
		case "$platform" in
			9g45)
				svn export ${project_svn_path}/trunk/OS/9G45/rootfs-dfb/rootfs.tar.bz2
				;;
			9263)
				svn export ${project_svn_path}/trunk/OS/9263/rootfs/rootfs-cramfs-3G.tar.bz2
				;;
			x86)
				svn export ${project_svn_path}/trunk/OS/N2600/rootfs-dfb/rootfs-v8.tar.bz2
				sudo rm usb_install -rf
				mkdir usb_install
				svn export ${project_svn_path}/trunk/OS/N2600/usb_install ./usb_install --force
				;;
			imx53)
				;;			
		esac
		#导出Resources。
		rm Resources -rf
		mkdir Resources
		svn export $mx_resources_svn ./Resources --force

		#获取trunk/Mx/Resources/bin下的文件
		mkdir bin_
		svn export ${project_svn_path}/trunk/Mx/Resources/bin bin_/ --force
		if [ "$machine" == "im20" ] ; then
			mv bin_/updater ./Resources/bin
			mv bin_/x12_updater.conf ./Resources/bin/updater.conf
			mv bin_/update ./Resources/bin
		elif [ "$machine" == "im50" ] ; then
			mv bin_/im50/updater-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/updater
			mv bin_/im50/updater.conf ./Resources/bin/updater.conf
			mv bin_/im50/update-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/update
		elif [ "$machine" == "im60" ] ; then
			mv bin_/im60/updater-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/updater
			mv bin_/im60/updater.conf ./Resources/bin/updater.conf
			mv bin_/im60/update-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/update
		elif [ "$machine" == "im70" ] ; then
			mv bin_/im70/updater-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/updater
			mv bin_/im70/updater.conf ./Resources/bin/updater.conf
			mv bin_/im70/update-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/update
		elif [ "$machine" == "im80" ] ; then
			mv bin_/im80/updater-"for"-arm-linux-gcc-4.6.4 ./Resources/bin/updater
			mv bin_/im80/updater.conf ./Resources/bin/updater.conf
			mv bin_/im80/update-for-arm-linux-gcc-4.6.4   ./Resources/bin/update
		elif [ "$machine" == "m80" ] ; then
			mv bin_/update ./Resources/bin
		elif [ "$machine" == "m50" ] ; then
			mv bin_/update ./Resources/bin
		elif [ "$machine" == "ims" ] ; then
			mv bin_/ims/update ./Resources/bin
			mv bin_/ims/updater ./Resources/bin
			mv bin_/ims/updater-ims-im50.conf ./Resources/bin
			mv bin_/ims/updater-ims-im60.conf ./Resources/bin
			mv bin_/ims/updater-ims-im70.conf ./Resources/bin
			mv bin_/ims/updater-ims-im80.conf ./Resources/bin
			mv bin_/ims/updater-ims-vista120s.conf ./Resources/bin
		fi
		#fbdump用于截图功能，都是按平台来分，目前只有三个平台支持
		if [ "$platform" == "9g45" ] || [ "$platform" == "imx53" ] || [ "$platform" == "imx6" ];then
			mv bin_/fbdump  ./Resources/bin
		fi

		rm bin_ -rf

		#获取最新的升级配置文件
		mkdir etc_
		svn export ${project_svn_path}/trunk/Mx/Resources/etc etc_/ --force
		if [ "$machine" == "im50" ] ; then
			mv etc_/ModuleUartCfg_im50 ./Resources/etc
		elif [ "$machine" == "im80" ] ; then
			mv etc_/ModuleUartCfg_im80 ./Resources/etc
		elif [ "$machine" == "im60" ] ; then
			mv etc_/ModuleUartCfg_im50 ./Resources/etc
		elif [ "$machine" == "im70" ] ; then
			mv etc_/ModuleUartCfg_im50 ./Resources/etc
		elif [ "$machine" == "m80" ] ; then
			mv etc_/ModuleUartCfg_im80 ./Resources/etc		#TODO
		elif [ "$machine" == "m50" ] ; then
			mv etc_/ModuleUartCfg_im50 ./Resources/etc		#TODO
		fi
		rm etc_ -rf

		#获取最新的多语言文件
		mkdir locale_
		svn export ${project_svn_path}/trunk/Mx/Documents/locale-xml/ locale_/ --force
		mv locale_/*.xml ./Resources/locale/
		rm locale_ -rf
	fi

	#布置Resources下的配置文件
	#生成AppConfig配置文件
	#生成触摸屏预校准文件pointercal
	if [ "$machine" == "im20" ] ; then
		cp ./Resources/etc/AppConfig-im20.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-im20 ./Resources/etc/pointercal
	elif [ "$machine" == "im50" ] ; then
		cp ./Resources/etc/AppConfig-im50.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/ModuleUartCfg_im50 ./Resources/etc/ModuleUartCfg
		cp ./Resources/etc/pointercal-im50 ./Resources/etc/pointercal
	elif [ "$machine" == "im60" ] ; then
		cp ./Resources/etc/AppConfig-im60.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/ModuleUartCfg_im50 ./Resources/etc/ModuleUartCfg
		cp ./Resources/etc/pointercal-im60 ./Resources/etc/pointercal
	elif [ "$machine" == "im70" ] ; then
		cp ./Resources/etc/AppConfig-im70.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/ModuleUartCfg_im50 ./Resources/etc/ModuleUartCfg
		cp ./Resources/etc/pointercal-im70 ./Resources/etc/pointercal
	elif [ "$machine" == "im80" ] ; then
		cp ./Resources/etc/AppConfig-im80.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/ModuleUartCfg_im80 ./Resources/etc/ModuleUartCfg
		cp ./Resources/etc/pointercal-im80 ./Resources/etc/pointercal
	#elif [ "$machine" == "ims" ] ; then
		# 在mx_daemon.sh中执行这个操作
		# cp ./Resources/etc/AppConfig-ims.xml ./Resources/etc/AppConfig.xml
		# iMS在首次烧录完开机后，强制执行校准生成校准文件。
		# cp ./Resources/etc/pointercal-ims ./Resources/etc/pointercal
	elif [ "$machine" == "v8" ] && [ "$platform" == "x86" ] ; then
		cp ./Resources/etc/AppConfig-v8_x86.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v8 ./Resources/etc/pointercal
	elif [ "$machine" == "v8" ] && [ "$platform" == "imx6" ] ; then
		cp ./Resources/etc/AppConfig-v8.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v8 ./Resources/etc/pointercal
	elif [ "$machine" == "m80" ] ; then
		cp ./Resources/etc/AppConfig-m80.xml ./Resources/etc/AppConfig.xml		#TODO
		cp ./Resources/etc/ModuleUartCfg_im80 ./Resources/etc/ModuleUartCfg		#TODO
	elif [ "$machine" == "m50" ] ; then
		cp ./Resources/etc/AppConfig-m50.xml ./Resources/etc/AppConfig.xml		#TODO
		cp ./Resources/etc/ModuleUartCfg_im50 ./Resources/etc/ModuleUartCfg		#TODO
	elif [ "$machine" == "v5" ] && [ "$platform" == "imx53" ] ; then
		cp ./Resources/etc/AppConfig-v5_imx53.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v5 ./Resources/etc/pointercal
	elif [ "$machine" == "v5" ] && [ "$platform" == "imx6" ] ; then
		cp ./Resources/etc/AppConfig-v5.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v5 ./Resources/etc/pointercal
	elif [ "$machine" == "v6" ] && [ "$platform" == "imx53" ] ; then
		cp ./Resources/etc/AppConfig-v6_imx53.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v6 ./Resources/etc/pointercal
	elif [ "$machine" == "v6" ] && [ "$platform" == "imx6" ] ; then
		cp ./Resources/etc/AppConfig-v6.xml ./Resources/etc/AppConfig.xml
		cp ./Resources/etc/pointercal-v6 ./Resources/etc/pointercal	
	fi
	#生成MxConfig配置文件
	cp ./Resources/etc/MxConfigAdult.xml ./Resources/etc/MxConfig.xml
	
	if [ -f ./Resources/etc/pointercal ] ; then
		md5sum ./Resources/etc/pointercal > ./Resources/etc/pointercal.md5sum
	fi
	
	#配置Resources 设备图片
	if [ "$machine" == "v5" ] ; then
		rm -rf ./Resources/pics/dev_pics
		cp  -rf ./Resources/pics/dev_pics_800_600 ./Resources/pics/dev_pics
	elif [ "$machine" == "v6" ] ; then
		rm -rf ./Resources/pics/dev_pics
		cp  -rf ./Resources/pics/dev_pics_1024_768 ./Resources/pics/dev_pics	
	fi
	
	#配置Resources 音频源文件,iMS系列机型的音频解压采样率是44KHz
	if [ "$machine" == "ims" ] ; then
		rm -rf ./Resources/sound
		cp  -rf ./Resources/sound_44kHz ./Resources/sound
	fi
	
	#生成bin文件
	cp ../testMx ./Resources/bin

	printf "check_files running...\n"

	# 检查文件是否存在，如果是XML文件，还会进行格式检查
	check_files "./Resources/etc" "$(cd ./Resources/etc; ls ./Resources/etc/*.xml)"
	check_files "./Resources/etc" "$etc_file_list"
	check_files "./Resources/locale" "$locale_file_list"
	check_files "./Resources/sound" "$sound_file_list"
	check_files "./Resources/sound/pulse_tone" "$pulse_tone_file_list"
	check_files "./Resources/fonts" "$font_file_list1"
	check_files "./Resources/mnt/fonts" "$font_file_list2"
	cd ./Resources/mnt/fonts
	md5sum $font_file_list2 > fonts.md5sum
	cd -
}

build_image_9g45() {
	cp ../LedSelfCheck ./Resources/bin
	cp ../FCUtil ./Resources/bin
	cp ../KeyboardFbdump ./Resources/bin
	cp ../progress ./Resources/bin

	sudo rm rootfs -rf
	sudo tar -jxf rootfs.tar.bz2

	#im20有机内存储功能，有格式化存储设备功能
	if ! cp $project_source_path/scripts/format.sh ./Resources/bin/format.sh ; then
		printf_red_bold "$project_source_path/scripts/format.sh NOT FOUND!\n"
		exit
	fi

	if [ "$machine" == "ims" ] ; then
		if ! cp $project_source_path/MxDaemon/mx_daemon-$machine.sh ./Resources/bin/mx_daemon.sh ; then
			printf_red_bold "$project_source_path/MxDaemon/mx_daemon-$machine.sh NOT FOUND!\n"
			exit
		fi
		cp ../FCUtil ./Resources/bin
	fi

	if ! cp $project_source_path/MxDaemon/fcutil_daemon.sh ./Resources/bin/fcutil_daemon.sh ; then
		printf_red_bold "$project_source_path/MxDaemon/fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi
	
	#填充/home/edan和/etc/edan，为rootfs.image做准备。
	sudo rm -rf ./rootfs/home/edan
	sudo rm -rf ./rootfs/etc/edan
	sudo cp ./Resources/ ./rootfs/home/edan -r
	sudo cp ./Resources/etc/  ./rootfs/etc/edan -r
	sudo cp ./Resources/bin/testMx ./rootfs/home/edan/bin/
	sudo cp ./Resources/bin/format.sh ./rootfs/home/edan/bin/
	sudo rm -rf ./rootfs/home/edan/etc/*
	sudo rm ./rootfs/etc/edan/AppConfig-*
	sudo rm ./rootfs/etc/edan/ModuleUartCfg_*
	# 清理/home/edan目录下冗余的其他采样率的sound文件
	sudo rm -rf ./rootfs/home/edan/sound_*

		if ! [ -x ./rootfs/home/edan/bin/format.sh ] ; then
			printf_red_bold "format.sh NOT FOUND!\n"
			exit
		fi

	if [ "$machine" == "ims" ] ; then
		if ! [ -x ./rootfs/home/edan/bin/mx_daemon.sh ] ; then
			printf_red_bold "mx_daemon.sh NOT FOUND!\n"
			exit
		fi
	fi

	if ! [ -x ./rootfs/home/edan/bin/fcutil_daemon.sh ] ; then
		printf_red_bold "fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi
	
	#填充config，config.image做准备。
	mkdir config
	cp ./Resources/etc/* config/ -r

	# config.image
	if [ $os_separate == "yes" ];then
		sudo mkfs.jffs2 -p -e 0x20000 -U -r config -o $target_dir/app.config.image
	else
		sudo mkfs.jffs2 -p -e 0x20000 -U -r config -o $target_dir/config.image
	fi
	sudo rm -rf config

	if [ $os_separate == "yes" ];then
		# app.image
		#sudo genromfs -d ./rootfs/home/edan/ -f $target_dir/app.image
		#sudo chmod 644 $target_dir/app.image

		sudo mkyaffs2image ./rootfs/home/edan $target_dir/yaffs2.image &>/dev/null
		sudo chmod 644 $target_dir/yaffs2.image

		sudo mkyaffsimage ./rootfs/home/edan $target_dir/yaffs.image &>/dev/null
		sudo chmod 644 $target_dir/yaffs.image
	else
		# yaffs2.image
		sudo mkyaffs2image ./rootfs/home/edan/mnt $target_dir/yaffs2.image &>/dev/null
		sudo chmod 644 $target_dir/yaffs2.image

		#yaffs.image
		sudo mkyaffsimage ./rootfs/home/edan/mnt $target_dir/yaffs.image &>/dev/null
		sudo chmod 644 $target_dir/yaffs.image
		sudo rm -rf ./rootfs/home/edan/mnt/*

		# rootfs.image
		sudo genromfs -d rootfs -f $target_dir/rootfs.image
	fi

	cd $target_dir

	for x in `ls` ; do
		md5sum $x > $x.md5sum
	done

	cp * /tftpboot

	cd -

	zipfile=$target_dir.zip

	zip -r $zipfile $target_dir

	mv $zipfile $zipfile_dir

	sudo rm -rfv $target_dir

}

build_image_9263() {
	cp ../LedSelfCheck ./Resources/bin
	cp ../KeyboardFbdump ./Resources/bin

	sudo rm rootfs -rf
	sudo tar jxf rootfs-cramfs-3G.tar.bz2

	sudo mv rootfs-cramfs-3G/rootfs ./
	sudo rm rootfs-cramfs-3G/ -rf

	#填充/home/edan和/etc/edan，为rootfs.image做准备。
	sudo rm -rf ./rootfs/home/edan
	sudo rm -rf ./rootfs/etc/edan
	sudo cp ./Resources/ ./rootfs/home/edan -r
	sudo cp ./Resources/etc/  ./rootfs/etc/edan -r
	sudo cp ./Resources/bin/testMx ./rootfs/home/edan/bin/
	sudo rm -rf ./rootfs/home/edan/etc/*

	#填充config，config.image做准备。
	mkdir config
	cp ./Resources/etc/* config/ -r

	# config.image
	sudo mkfs.jffs2 -p -e 0x20000 -U -r config -o $target_dir/config.image
	sudo rm -rf config

	# yaffs.image
	sudo mkyaffsimage ./rootfs/home/edan/mnt $target_dir/yaffs.image
	sudo chmod 644 $target_dir/yaffs.image
	sudo rm -rf ./rootfs/home/edan/mnt/*

	######## rootfs.image 需要删除一些内容以满足能在M50/M80上放下 #########
	#删除/home/edan下的部分文件
	sudo rm rootfs/home/edan/pics/dev_pics/ -rf
	# 制作rootfs.image
	sudo mkfs.cramfs ./rootfs $target_dir/rootfs.image

	cd $target_dir

	for x in `ls` ; do
		md5sum $x > $x.md5sum
	done

	cp * /tftpboot

	cd -

	zipfile=$target_dir.zip

	zip -r $zipfile $target_dir

	mv $zipfile $zipfile_dir

	sudo rm -rfv $target_dir
}

build_image_imx53(){
	local image_dir=${PWD}
	cp ../../Functions/Update/update_script ./Resources/bin
	cp ../pam_update ./Resources/bin
	cp ../FCUtil ./Resources/bin
	cp ../KeyboardFbdump ./Resources/bin
	cp ../progress ./Resources/bin

	if ! cp $project_source_path/MxDaemon/mx_daemon-$machine.sh ./Resources/bin/mx_daemon.sh ; then
		printf_red_bold "$project_source_path/MxDaemon/mx_daemon-$machine.sh NOT FOUND!\n"
		exit
	fi

	if ! cp $project_source_path/MxDaemon/fcutil_daemon.sh ./Resources/bin/fcutil_daemon.sh ; then
		printf_red_bold "$project_source_path/MxDaemon/fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi

	#填充app，为app.image做准备
	mkdir -p app
	sudo rm  -rf app/*
	sudo cp ./Resources/* ./app/ -r	
	sudo cp ./Resources/bin/testMx ./app/bin/
	sudo rm ./app/etc/*

	if ! [ -x ./app/bin/mx_daemon.sh ] ; then
		printf_red_bold "mx_daemon.sh NOT FOUND!\n"
		exit
	fi

	if ! [ -x ./app/bin/fcutil_daemon.sh ] ; then
		printf_red_bold "fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi

	#填充config，config.image做准备。
	sudo rm -rf config
	mkdir -p config
	sudo cp ./Resources/etc/* config/ -r

	#填充recovery-config，为recovery-config.image准备
	sudo rm -rf recovery-config
	mkdir -p recovery-config
	sudo cp -r config/* recovery-config/
	sudo rm recovery-config/AppConfig-*
	sudo rm recovery-config/ModuleUartCfg_*

	#修改文件系统权限
	sudo chown -R root:root config app recovery-config

	# recovery-config.image
	sudo mkfs.cramfs recovery-config $target_dir/recovery-config.image

	# config.image
	sudo mkfs.jffs2 -p -e 0x20000 -U -r config -o $target_dir/config.image
	
	# app.image
	sudo genromfs -d app -f $target_dir/app.image

	cd $target_dir

	for x in `ls` ; do
		md5sum $x > $x.md5sum
	done

	cp * /tftpboot

	cd -

	zipfile=$target_dir.zip

	zip -r $zipfile $target_dir

	mv $zipfile $zipfile_dir

	sudo rm -rfv $target_dir
}

build_image_imx6() {
	local image_dir=${PWD}
	cp ../../Functions/Update/update_script ./Resources/bin
	cp ../pam_update ./Resources/bin
	cp ../FCUtil ./Resources/bin
	cp ../KeyboardFbdump ./Resources/bin
	cp ../progress ./Resources/bin
	
	if ! cp $project_source_path/scripts/format.sh ./Resources/bin/format.sh ; then
		printf_red_bold "$project_source_path/scripts/format.sh NOT FOUND!\n"
		exit
	fi

	if ! cp $project_source_path/MxDaemon/mx_daemon-$machine.sh ./Resources/bin/mx_daemon.sh ; then
		printf_red_bold "$project_source_path/MxDaemon/mx_daemon-$machine.sh NOT FOUND!\n"
		exit
	fi

	if ! cp $project_source_path/MxDaemon/fcutil_daemon.sh ./Resources/bin/fcutil_daemon.sh ; then
		printf_red_bold "$project_source_path/MxDaemon/fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi

	#填充app，为app.image做准备
	mkdir -p app
	sudo rm  -rf app/*
	sudo cp ./Resources/* ./app/ -r	
	sudo cp ./Resources/bin/testMx ./app/bin/
	sudo cp ./Resources/bin/format.sh ./app/bin/
	sudo rm ./app/etc/*

	if ! [ -x ./app/bin/mx_daemon.sh ] ; then
		printf_red_bold "mx_daemon.sh NOT FOUND!\n"
		exit
	fi

	if ! [ -x ./app/bin/fcutil_daemon.sh ] ; then
		printf_red_bold "fcutil_daemon.sh NOT FOUND!\n"
		exit
	fi

	if ! [ -x ./app/bin/format.sh ] ; then
		printf_red_bold "format.sh NOT FOUND!\n"
		exit
	fi

	#填充config，config.image做准备。
	sudo rm -rf config
	mkdir -p config
	sudo cp ./Resources/etc/* config/ -r

	#填充recovery-config，为recovery-config.image准备
	sudo rm -rf recovery-config
	mkdir -p recovery-config
	sudo cp -r config/* recovery-config/
	sudo rm recovery-config/AppConfig-*
	sudo rm recovery-config/ModuleUartCfg_*

	#修改文件系统权限
	sudo chown -R root:root config app recovery-config

	cd app
	sudo tar -jcf ../$target_dir/app.tar.bz2 *
	cd -
	cd config
	sudo tar -jcf ../$target_dir/config.tar.bz2 *
	cd -
	cd recovery-config
	sudo tar -jcf ../$target_dir/recovery-config.tar.bz2 *
	cd -

	cd $target_dir

	for x in `ls` ; do
		md5sum $x > $x.md5sum
	done

	cp * /tftpboot

	cd -

	zipfile=$target_dir.zip

	zip -r $zipfile $target_dir

	mv $zipfile $zipfile_dir

	sudo rm -rfv $target_dir
}


build_image_x86() {
	cp ../../Functions/Update/update_script ./Resources/bin
	cp ../pam_update ./Resources/bin
	cp ../FCUtil ./Resources/bin
	cp ../fan_rev ./Resources/bin
	cp ../KeyboardFbdump ./Resources/bin
	cp ../progress ./Resources/bin

	cd usb_install
	sudo ./build.sh
	cd ..

	if [ -f /tftpboot/usb_install.img ] ; then
	
		cp /tftpboot/usb_install.img $target_dir
		zipfile=$target_dir.zip
		zip -r $zipfile $target_dir
		mv $zipfile $zipfile_dir

		sudo rm -rfv $target_dir
	fi
}

build_image () {
	local machine=$(echo $machine | tr 'A-Z' 'a-z')
	local platform=$(echo $platform | tr 'A-Z' 'a-z')
	local buid_dir=build-$platform-$machine
	local image_dir=image

	cd $project_source_path

	if [ -d $buid_dir  ] && [ -x $buid_dir/testMx ] ; then
		cd $buid_dir
	else
		printf_red_bold "Directory: $buid_dir could not be found!\n"
		printf_red_bold "OR File: testMx could not be found!\n"
		printf_red_bold "You should build Mx project firstly!\n"
		exit 1
	fi	

	if [ -d $image_dir ] ; then
		cd $image_dir
	elif [ "$need_refresh" != "refresh" ] ; then
		printf_red_bold "Directory \"image\" is not found!\n"
		printf_red_bold "Maybe you should specify the 2nd param:\"refresh\"!\n "
		exit 3
	else
		mkdir $image_dir
		cd $image_dir
	fi
	
	export_resource
	echo "Running : build_image_"$platform""

	target_dir=MxTarget-$project_revision-$machine-$platform-$build_time
	mkdir $target_dir

	build_image_"$platform"
	
	cd $project_source_path
}


build_help(){
  printf_bold "OPTIONS:\n"
  printf_bold "        -m Specify the image file you need to download the compiled into machine \n"
  printf_bold "        eg:-m im20/im50/im60/im70/im80/ims/m50/m80/v5/v6/v8 \n"	
  printf_bold "        -p Supporting machine main control board,v5/v6 must be entered,other machine ignore this option \n"
  printf_bold "        eg:-p imx53/imx6 \n"
  printf_bold "        -r if you need to refresh,enter this option \n"
  printf_bold "        -s if separate OS and app,enter this option, only for 9G45 platform so far\n"
  printf_bold "        eg:-p imx53/imx6 \n"

  printf_bold "        ./build-image.sh -p imx6 -m V6 -r\n"							
}

#获取命令行传递进来的参数
while getopts ":p:m:rs" opt
do
	case $opt in 
		p) 
			platform=$OPTARG
		;;
		m)
		    	machine=$OPTARG
		;;
		r)
		    	need_refresh="refresh"
		;;
		s)
		    	os_separate="yes"
		;;
		*)
		     printf_red_bold "ERROR:You enter -$OPTARG non-existent option!\n"
		     build_help
		     exit 2
		;;
	esac
done
shift $(($OPTIND - 1))

if [ "$machine" == "" ] ; then
	printf_red_bold "Please specify the machine name !\n"
	build_help
	exit 3
fi

if [ -n "$2" ] && [ "$need_refresh" != "refresh" ]; then
	printf_red_bold "Please Check your speelling for \"refresh\"!\n"
	exit 2
fi

if ! [ -d $MxTarget_dir ] ; then
	mkdir -p $MxTarget_dir
fi

# 把$zipfile_dir历史数据转移到History目录下
if [ $(ls $MxTarget_dir | wc -l) -ge 1 ] ; then
	mkdir -p $MxTarget_dir/History

	# 如果$zipfile_dir/History/目录下版本数大于20个，则先删除历史构建Mx映像
	if [ $(ls $MxTarget_dir/History | wc -l) -gt 20 ] ; then  
		rm -rf $MxTarget_dir/History/*
	fi

	for x in `ls $MxTarget_dir` ; do
		if [ $x != $project_revision ] && [ $x != "History" ] ; then
			mv $MxTarget_dir/$x $MxTarget_dir/History/
		fi
	done
fi

if ! [ -d $zipfile_dir ] ; then
	mkdir -p $zipfile_dir
fi

machine=$(echo $machine | tr 'A-Z' 'a-z')
platform=$(echo $platform | tr 'A-Z' 'a-z')

case "$machine"  in
	im20|im50|im60|im70|im80)
		#if [ "$platform" == "" ] ; then
		#	platform="9g45"
		#fi
		platform="9g45"
		build_image $machine $platform
		;;
	ims)
		os_separate="yes"
		platform="9g45"
		build_image $machine $platform
		;;
	m50|m80)
		platform="9263"
		build_image $machine $platform	
		;;
	v8)	
		build_image $machine $platform
		;;
	v5|v6)
		#platform=$platform
		#V5/V6有两个板卡，这里的platform由于命令行进行指定
		if [ -z "$platform" ] || ( [ "$platform" != "imx53" ] && [ "$platform" != "imx6" ] ) ; then
			printf_red_bold "v5/v6 only supports two types of main board,which are imx53 and imx6!\n"
			printf_red_bold "Please re-enter -p parameters: imx53 or imx6 !\n"
			exit 2
		fi
		build_image $machine $platform
		;;
	*)
		printf_red_bold "The machine name is incorrect!\n"
		exit 1
		;;
esac
