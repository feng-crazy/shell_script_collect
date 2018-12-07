#!/bin/sh

#待构建平台
support_platforms="9g45 imx53 imx6 x86"

#待构建机型
platform_9g45_machines="im20 im50 im60 im70 im80 ims"
platform_imx6_machines="v5 v6 v8"
platform_imx53_machines="v5 v6"
platform_x86_machines="v8"

#源码src目录路径
root_dir=$(pwd)

BuildMx () {
	local platform=$1
	local machine=$2

	cd $root_dir
	echo "./cmake-mx.sh -p $platform -m $machine"
	./cmake-mx.sh -p $platform -m $machine
	if [ -d build-$x-$y ] ; then
		cd build-$x-$y
		if make -j8 ; then
		       #单元测试不需要打包
			if [ "$machine" != "cppunit" ] ; then
				cd $root_dir
				./build-image.sh -p $x -m $y -r
			fi
		fi
	fi

}

UnitTest()
{
	local platform=$1
	local machine=$2

	if [ "$machine" != "cppunit" ] ; then
		echo "UnitTest should Only support machine-type:cppunit - $machine!"
		return
	fi

	cd $root_dir
	echo "./cmake-mx.sh -p $platform -m $machine"
	./cmake-mx.sh -p $platform -m $machine
	if [ -d build-$platform-$machine ] ; then
		cd build-$platform-$machine
		if make -j8 ; then
			echo "UnitTest Run Successfully!"
		else
			echo "UnitTest Fault, Please Check your SourceCode then run again!"
			exit 
		fi
	fi	
}

UnitTest x86 cppunit

for x in ${support_platforms} ;
do
	case "$x" in
		9g45)
			for y in $platform_9g45_machines ; 
			do
				cd $root_dir
				BuildMx $x $y
			done
			;;
		imx6)
			for y in $platform_imx6_machines ; 
			do
				cd $root_dir
				BuildMx $x $y
			done
			;;
		imx53)
			for y in $platform_imx53_machines ; 
			do
				cd $root_dir
				BuildMx $x $y
			done
			;;
		x86)
			for y in $platform_x86_machines ; 
			do
				cd $root_dir
				BuildMx $x $y
			done
			;;
	esac
done


