#!/bin/bash
############################################################################
#	  COPYRIGHT: 2009 Edan Instruments, Inc. All rights reserved
#	PROJECTNAME: Mx
#		VERSION:
#	   FILENAME: cmake-mx.sh
#		CREATED: 2012.07.26
#		 AUTHOR: 张虎
#	DESCRIPTION: 配置Mx
############################################################################

PROJECT_SOURCE_PATH=$(pwd)

make_im50_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im50)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序
	
	local devices_list="C2Device C3Device G2Device C5Device NellcorDevice PS900Device X5Device T2Device"
	#local devices_list="C2Device C3Device G2Device C5Device NellcorDevice PMUDevice X5Device T2Device"
	
	local modules_list="CO2Module COModule ECGModule IBPModule NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule QuickTempModule"
					
	local functions_list="ConfigManager MCDStore Record ClinicStore"
			
	local network_features_list="Ethernet 3G"
											
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done		
	
	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done

	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake   #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake   #支持数据存储
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake   #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake   #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake   #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake   #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}

make_im80_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im80)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="A8Device A8PlusDevice C2Device C3Device C5Device E6Device E6PlusDevice E8Device G2Device
					HTDevice M3600Device NellcorDevice PhaseinDevice DraegerDevice PS900Device V6Device X2Device"
	
	local modules_list="AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module CO2Module 
					COModule ECGModule IBPModule NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule"
	local functions_list="ConfigManager MCDStore Record"
											
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done
		
	local network_features_list="Ethernet 3G"

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done		
	
	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done	
	
	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake   #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake   #支持数据存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake   #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake   #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake   #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}

make_im20_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im20)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(NO_3GCARD 0)"                   >> build-config.cmake   #支持3G:set(NO_3GCARD 0); 不支持3G:set(NO_3GCARD 1);iM50、iM80支持3G.
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序
	
	local devices_list="A8Device A8PlusDevice ClientDevice HostDevice 
					C2Device C3Device C5Device EFMDevice HTDevice SyncDevice X12Device X5Device NellcorDevice PMUDevice"
	
	local modules_list="CO2Module COModule ECGModule IBPModule NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule"
					
	local functions_list="ConfigManager MCDStore SyncDaemon"
											
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done
		
	local network_features_list="WIFI 3G"

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done		
	
	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done	

	echo "set(NO_VIEWBED 1)"                  >> build-config.cmake   #不支持它床
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}

make_im60_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im60)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="C2Device C3Device G2Device C5Device NellcorDevice PS900Device X5Device"
	
	local modules_list="CO2Module COModule ECGModule IBPModule NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule"
					
	local functions_list="ConfigManager MCDStore Record ClinicStore"
			
	local network_features_list="Ethernet WIFI 3G"
											
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done		
	
	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done
	
	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake   #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake   #支持数据存储
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake   #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake   #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake   #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake   #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}

make_im70_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im70)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="C2Device C3Device C5Device G2Device
					 M3600Device NellcorDevice PhaseinDevice DraegerDevice PS900Device X5Device "
		
	local modules_list="AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module CO2Module COModule ECGModule IBPModule  NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule"
						
	local functions_list="ConfigManager MCDStore Record ClinicStore"
		
	local network_features_list="Ethernet WIFI"
	
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done

	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done

	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake   #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake   #支持数据存储
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake   #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake   #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake   #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake   #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}
make_v5_config() {
	rm -f build-config-v5
	echo "add_definitions(-DMCU_IMX53)"    >> build-config.cmake   #Freescale iMx53平台(v6)

	echo "set(USE_PAM 1)"		          >> build-config.cmake     #插件式监护仪支持插件箱
	echo "set(USE_LED_SELFCHECK 0)"		  >> build-config.cmake	    #不使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	    #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="AspectBISDevice A8PlusDevice C2Device C3Device C5Device G2Device
					HTDevice M3600Device 
					ClientDevice HostDevice 
					EFMDevice MDMaepEXDevice MedisICGDevice MultiDevice MercuryDevice NellcorDevice PhaseinDevice DraegerDevice
					PMUDevice SyncDevice X12Device XmDevice Xm2Device NMTDevice"
		
	local modules_list="AEPModule AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module BISModule CO2Module 
					COModule ECGModule IBPModule ICGModule NIBPModule PowerModule PRModule RESPModule 
					RMCO2Module RMModule SpO2Module TEMPModule NMTModule"
						
	local functions_list="ConfigManager MCDStore Print Record SyncDaemon"
		
	local network_features_list="Ethernet WIFI"
	
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done

	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done

	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake     #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake     #支持数据存储
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake     #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake     #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake     #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake     #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake     #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake		#支持IBP波形叠加
	echo "set(CONFIG_PLUGIN Plugin)"          >> build-config.cmake	#插件式的特殊处理

}

make_v6_config() {
	rm -f build-config-v6
	echo "add_definitions(-DMCU_IMX53)"    >> build-config.cmake   #Freescale iMx53平台(v6)

	echo "set(USE_PAM 1)"		          >> build-config.cmake     #插件式监护仪支持插件箱
	echo "set(USE_LED_SELFCHECK 0)"		  >> build-config.cmake	    #不使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序
	
	local devices_list="AspectBISDevice A8PlusDevice C2Device C3Device C5Device G2Device
					HTDevice M3600Device 
					ClientDevice HostDevice 
					EFMDevice MDMaepEXDevice MedisICGDevice MultiDevice MercuryDevice NellcorDevice PhaseinDevice DraegerDevice
					PMUDevice SyncDevice X12Device XmDevice Xm2Device NMTDevice"
		
	local modules_list="AEPModule AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module BISModule CO2Module 
					COModule ECGModule IBPModule ICGModule NIBPModule PowerModule PRModule RESPModule 
					RMCO2Module RMModule SpO2Module TEMPModule NMTModule"
						
	local functions_list="ConfigManager MCDStore Print Record SyncDaemon"
		
	local network_features_list="Ethernet WIFI"
	
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done

	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done
	
	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake     #支持可移动存储设备
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake     #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake     #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake     #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake     #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake     #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake		#支持IBP波形叠加
	echo "set(CONFIG_PLUGIN Plugin)"          >> build-config.cmake	#插件式的特殊处理
}

make_v8_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_X86)"    	  >> build-config.cmake     #intel x86-atom平台(V8)

	echo "set(USE_PAM 1)"		          >> build-config.cmake     #插件式监护仪支持插件箱
	echo "set(USE_LED_SELFCHECK 0)"		  >> build-config.cmake	    #不使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 1)"		  >> build-config.cmake	    #V8使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="AspectBISDevice A8PlusDevice C2Device C3Device C5Device G2Device
					HTDevice M3600Device ClientDevice HostDevice 
					EFMDevice MDMaepEXDevice MedisICGDevice MultiDevice MercuryDevice NellcorDevice PhaseinDevice DraegerDevice
					PMUDevice SyncDevice X12Device XmDevice Xm2Device NMTDevice"
		
	local modules_list="AEPModule AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module BISModule CO2Module 
					COModule ECGModule IBPModule ICGModule NIBPModule PowerModule PRModule RESPModule 
					RMCO2Module RMModule SpO2Module TEMPModule NMTModule"
						
	local functions_list="ConfigManager MCDStore Print Record SyncDaemon"
		
	if [ $PLATFORM == "imx6" ]; then
		local network_features_list="Ethernet WIFI"
	else 
		local network_features_list="Ethernet"
	fi
	
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done

	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done

	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake     #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake     #支持数据存储
	echo "set(NO_DATA_STORE_WAVE 0)"          >> build-config.cmake     #支持数据存储的波形存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake     #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake     #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake     #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake     #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake		#支持IBP波形叠加
	echo "set(CONFIG_PLUGIN Plugin)"          >> build-config.cmake	#插件式的特殊处理
}

make_cppunit_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_X86)"    	  >> build-config.cmake     #intel x86-atom平台(V8)

	echo "set(CONFIG_CPPUNIT 1)"        	  >> build-config.cmake

	local devices_list="AspectBISDevice A8PlusDevice C2Device C3Device C5Device G2Device
					HTDevice M3600Device ClientDevice HostDevice 
					EFMDevice MDMaepEXDevice MedisICGDevice MultiDevice MercuryDevice NellcorDevice PhaseinDevice DraegerDevice
					PMUDevice SyncDevice X12Device XmDevice Xm2Device"
		
	local modules_list="AEPModule AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module BISModule CO2Module 
					COModule ECGModule IBPModule ICGModule NIBPModule PowerModule PRModule RESPModule 
					RMCO2Module RMModule SpO2Module TEMPModule"
						
	local functions_list="ConfigManager MCDStore Print Record SyncDaemon"
		
	if [ $PLATFORM == "imx6" ]; then
		local network_features_list="Ethernet WIFI"
	else 
		local network_features_list="Ethernet"
	fi
	
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done

	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done

	mkdir lib
}

make_ims_config() {
	rm -f build-config.cmake

	echo "add_definitions(-DMCU_ATMEL_AT91SAM9G45)"    >> build-config.cmake   #atmel at91sam9g45平台(im80)

	echo "set(USE_PAM 0)"		          >> build-config.cmake   #非插件式监护仪不支持插件箱
	echo "set(USE_LED_SELFCHECK 1)"		  >> build-config.cmake	  #使用独立的LedSelfCheck程序
	echo "set(USE_FAN_CTRL 0)"		  >> build-config.cmake	  #不使用独立的FanRev风扇控制程序
	echo "set(USE_KEYBOARD_FBDUMP 1)"	 >> build-config.cmake	  #使用独立的KeyboardFbdump键盘截图程序

	local devices_list="X12Device NellcorDevice HTDevice M3600Device C2Device C3Device   
						C5Device G2Device PhaseinDevice DraegerDevice PMUDevice T2Device GASExtendDevice"
	
	local modules_list="AGAAModule AGCO2Module AGModule AGN2OModule AGO2Module CO2Module 
					COModule ECGModule IBPModule NIBPModule PowerModule PRModule RESPModule 
					SpO2Module TEMPModule QuickTempModule"
	local functions_list="ConfigManager MCDStore Record Print"
											
	for device in ${devices_list} ; do
		echo "set(CONFIG_${device} 1)"        >> build-config.cmake
	done
		
	local network_features_list="Ethernet WIFI 3G"

	for module in ${modules_list} ; do
		echo "set(CONFIG_${module} 1)"        >> build-config.cmake
	done		
	
	for function in ${functions_list} ; do
		echo "set(CONFIG_${function} 1)"        >> build-config.cmake
	done

	for network in ${network_features_list} ; do
		echo "set(CONFIG_${network} 1)"        >> build-config.cmake
	done	
	
	echo "set(NO_STORAGE_DEV 0)"              >> build-config.cmake   #支持可移动存储设备
	echo "set(NO_DATA_STORE 0)"               >> build-config.cmake   #支持数据存储
	echo "set(NO_U_DISK_CONFIG_MANAGER 1)"    >> build-config.cmake   #不支持U盘配置管理
	echo "set(NO_OLD_NETWORK 0)"              >> build-config.cmake   #支持中央站老协议
	echo "set(NO_VIEWBED 0)"                  >> build-config.cmake   #支持它床
	echo "set(NO_NIGHT_MODE 0)"               >> build-config.cmake   #支持夜间模式
	echo "set(NO_IBP_WAVEFORM_OVERLAY 0)"     >> build-config.cmake   #支持IBP波形叠加
	echo "set(CONFIG_PLUGIN NonPlugin)"       >> build-config.cmake	#非插件式的特殊处理
}

cmake_arm () {
	cd $PROJECT_SOURCE_PATH
	
	sudo rm -rf $BUILD_DIR
	mkdir $BUILD_DIR
	cd $BUILD_DIR

	make_"$MACHINE"_config 

	local CMAKE_MACHINE_TYPE=$(echo $MACHINE | tr 'a-z' 'A-Z')
	local CMAKE_PLATFORM_TYPE=$(echo $PLATFORM | tr 'a-z' 'A-Z')
	
	echo "set(BUILD_TYPE ${BUILD_TYPE})"		>> build-config.cmake
	echo "set(CONFIG_MACHINE ${MACHINE})"		>> build-config.cmake
	echo "set(CONFIG_PLATFORM ${PLATFORM})"		>> build-config.cmake
	
	if ! cmake -DCMAKE_MACHINE_TYPE=${CMAKE_MACHINE_TYPE} -DCMAKE_PLATFORM_TYPE=${CMAKE_PLATFORM_TYPE} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_TOOLCHAIN_FILE=../arm-linux-gcc.cmake -C../fltk.cmake .. ; then
		echo "errors occurred: 请检查错误信息，修改错误后再重新执行命令"
		exit 1
	fi

	cp ../lib/hl7-arm.a lib/libhl7.a
	cp ../lib/ecg-analysis-arm.a lib/libecg-analysis.a
	cp ../lib/libpnpdisk-arm.a lib/libpnpdisk.a
	cp ../lib/libsemip-arm.a lib/libsemip.a

	# im80支持E6，需要E6的ISEAP1.0算法包
	if [ "$1" == "im80" ]; then
		cp ../lib/ecg-analysis-e6-arm.a lib/libecg-analysis.a
	fi

	cd ..
	
}

cmake_x86 () {
	cd $PROJECT_SOURCE_PATH
	
	sudo rm -rf $BUILD_DIR
	mkdir $BUILD_DIR
	cd $BUILD_DIR
	
	make_"$MACHINE"_config 

	local CMAKE_MACHINE_TYPE=$(echo $MACHINE | tr 'a-z' 'A-Z')
	local CMAKE_PLATFORM_TYPE=$(echo $PLATFORM | tr 'a-z' 'A-Z')
	
	echo "set(BUILD_TYPE ${BUILD_TYPE})"		>> build-config.cmake
	echo "set(CONFIG_MACHINE ${MACHINE})"		>> build-config.cmake
	echo "set(CONFIG_PLATFORM ${PLATFORM})"		>> build-config.cmake
	
	if ! cmake -DCMAKE_MACHINE_TYPE=${CMAKE_MACHINE_TYPE} -DCMAKE_PLATFORM_TYPE=${CMAKE_PLATFORM_TYPE} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -C../fltk.cmake .. ; then
		echo "errors occurred: 请检查错误信息，修改错误后再重新执行命令"
		exit 1
	fi

	cp ../lib/hl7-x86.a lib/libhl7.a
	cp ../lib/ecg-analysis-x86.a lib/libecg-analysis.a
	cp ../lib/libpnpdisk-x86.a lib/libpnpdisk.a
	cp ../lib/libsemip-x86.a lib/libsemip.a
	cd ..
	
}

printf_red_bold () {
	printf "\033[31;1m$1\033[0m"
}

printf_bold () {
	printf "\033[1m$1\033[0m"
}

build_help(){
  printf_bold "OPTIONS:\n"
  printf_bold "        -m Specify the image file you need to download the compiled into machine \n"
  printf_bold "        eg:-m im20/im50/im60/im70/im80/m50/m80/ims/v5/v6/v8 \n"	
  printf_bold "        -p Supporting machine main control board,v5/v6/v8 must be entered,other machine ignore this option \n"
  printf_bold "        eg:-p imx53/imx6/9g45/9263 \n"
  printf_bold "        -d if you need to build debug,enter this option \n"
  printf_bold "        eg:-p imx53/imx6 \n"

  printf_bold "        ./cmake-mx.sh -p imx6 -m V6 -d\n"							
}

#获取命令行传递进来的参数
while getopts ":p:m:d" opt
do
	case $opt in 
		p) 
				PLATFORM=$OPTARG
		;;
		m)
		    	MACHINE=$OPTARG
		;;
		d)
		    	DEBUG_RELEASE="debug"
		;;
		*)
		     printf_red_bold "ERROR:You enter -$OPTARG non-existent option!\n"
		     build_help
		     exit 2
		;;
	esac
done
shift $(($OPTIND - 1))

MACHINE=$(echo $MACHINE | tr 'A-Z' 'a-z')
PLATFORM=$(echo $PLATFORM | tr 'A-Z' 'a-z')
DEBUG_RELEASE=$(echo $DEBUG_RELEASE | tr 'A-Z' 'a-z')

BUILD_DIR=build-$PLATFORM-$MACHINE

if [ "$DEBUG_RELEASE" == "debug" ] ; then
	BUILD_TYPE=Debug
else
	BUILD_TYPE=Release
fi

case "$MACHINE"  in
	im20|im50|im60|im70|im80|m50|m80|ims|v5|v6)
		cmake_arm  $MACHINE
		;;
	v8)	
		if [ "$PLATFORM" == "imx6" ] ; then
			cmake_arm   $MACHINE
		else
			cmake_x86  $MACHINE
		fi
		;;
	cppunit)
		cmake_x86  $MACHINE
		;;
	*)
		;;
esac

