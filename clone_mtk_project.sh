#!/bin/sh

readonly usage="\

Usage: 
	$0 clone <base_project> <new_project>
	$0 clean <new_project>

Examples:
	$0 clone m1023_6ttb_m m742_base
	$0 clean m742_base
"

readonly PL_PATH="vendor/mediatek/proprietary/bootable/bootloader/preloader/custom"
readonly LK_PATH="vendor/mediatek/proprietary/bootable/bootloader/lk"
readonly KERNEL_PATH="kernel-3.18"

# 显示帮助
function show_help()
{
	echo -e "$usage"
}

# 克隆preloader 
function clone_pl()
{
	echo "clone preloader::++++++++++"
	
	cd ${TOP_DIR}/${PL_PATH}
	echo $(pwd)

	cp -r ${BASE_PROJECT} ${NEW_PROJECT}
	mv ${NEW_PROJECT}/${BASE_PROJECT}.mk ${NEW_PROJECT}/${NEW_PROJECT}.mk
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${NEW_PROJECT}/${NEW_PROJECT}.mk

	echo "clone preloader::----------"
}

# 克隆lk
function clone_lk()
{
	echo "clone lk::++++++++++"
	
	cd ${TOP_DIR}/${LK_PATH}
	echo $(pwd)

	cp project/${BASE_PROJECT}.mk project/${NEW_PROJECT}.mk
	cp -r target/${BASE_PROJECT} target/${NEW_PROJECT}
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g project/${NEW_PROJECT}.mk
	# sed -i "s/^TARGET .*$/TARGET  :=$2/g" project/${NEW_PROJECT}.mk 

	# sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g target/${NEW_PROJECT}/include/target/cust_usb.h

	echo "clone lk::----------"
}

# 克隆kernel
function clone_kernel()
{
	echo "clone kernel::++++++++++"

	cd ${TOP_DIR}/${KERNEL_PATH}
	echo $(pwd)

	cp -r drivers/misc/mediatek/mach/mt6735/${BASE_PROJECT} drivers/misc/mediatek/mach/mt6735/${NEW_PROJECT}
	cp arch/arm64/configs/${BASE_PROJECT}_debug_defconfig  arch/arm64/configs/${NEW_PROJECT}_debug_defconfig
	cp arch/arm64/configs/${BASE_PROJECT}_defconfig  arch/arm64/configs/${NEW_PROJECT}_defconfig
	cp arch/arm64/boot/dts/${BASE_PROJECT}.dts	arch/arm64/boot/dts/${NEW_PROJECT}.dts
	
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g arch/arm64/configs/${NEW_PROJECT}_defconfig
	#sed -i "s/^CONFIG_ARCH_MTK_PROJECT.*$/CONFIG_ARCH_MTK_PROJECT=\"${NEW_PROJECT}\"/g" arch/arm64/configs/${NEW_PROJECT}_defconfig
	#sed -i "s/^CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE_NAMES.*$/CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE_NAMES=\"${NEW_PROJECT}\"/g" arch/arm64/configs/${NEW_PROJECT}_defconfig


	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g arch/arm64/configs/${NEW_PROJECT}_debug_defconfig
	#sed -i "s/^CONFIG_ARCH_MTK_PROJECT.*$/CONFIG_ARCH_MTK_PROJECT=\"${NEW_PROJECT}\"/g" arch/arm64/configs/${NEW_PROJECT}_debug_defconfig
	#sed -i "s/^CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE_NAMES.*$/CONFIG_BUILD_ARM_APPENDED_DTB_IMAGE_NAMES=\"${NEW_PROJECT}\"/g" arch/arm/configs/${NEW_PROJECT}_debug_defconfig
	
	# Camera 
	cp -r drivers/misc/mediatek/imgsensor/src/mt6735/camera_project/${BASE_PROJECT} drivers/misc/mediatek/imgsensor/src/mt6735/camera_project/${NEW_PROJECT}


	echo "clone kernel::----------"
}

# 克隆android
function clone_android()
{
	echo "clone android::++++++++++"
	
	cd ${TOP_DIR}
	echo $(pwd)
	
	# Android Part I --> device config
	cp -r device/maisui/${BASE_PROJECT} device/maisui/${NEW_PROJECT}
	mv device/maisui/${NEW_PROJECT}/full_${BASE_PROJECT}.mk device/maisui/${NEW_PROJECT}/full_${NEW_PROJECT}.mk
	
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g  device/maisui/${NEW_PROJECT}/vendorsetup.sh
	sed -i s/full_${BASE_PROJECT}.mk/full_${NEW_PROJECT}.mk/g  device/maisui/${NEW_PROJECT}/AndroidProducts.mk   
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g  device/maisui/${NEW_PROJECT}/full_${NEW_PROJECT}.mk  
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g  device/maisui/${NEW_PROJECT}/device.mk   
	sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g  device/maisui/${NEW_PROJECT}/BoardConfig.mk
	
	# Android Part II --> 
	cp -r vendor/mediatek/proprietary/custom/${BASE_PROJECT} vendor/mediatek/proprietary/custom/${NEW_PROJECT} 
	sed -i "s/${BASE_PROJECT}/${NEW_PROJECT}/" vendor/mediatek/proprietary/custom/${NEW_PROJECT}/Android.mk

	# Android Part III --> 
	cp vendor/mediatek/proprietary/trustzone/custom/build/project/${BASE_PROJECT}.mk vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk
	
	# Android Part IV --> 
	cp -r vendor/wheatek/${BASE_PROJECT} vendor/wheatek/${NEW_PROJECT}

	echo "clone android::----------"
}

# 克隆新项目
function clone()
{
	echo "clone ::++++++++++"

	clone_pl
	clone_lk
	clone_kernel
	clone_android

	echo "clone ::----------"
}



# 清除克隆项目的preloader部分 
function clean_pl()
{
	echo "clean preloader::++++++++++"
	
	cd ${TOP_DIR}/${PL_PATH}
	echo $(pwd)

	rm -r ${NEW_PROJECT}
	
	echo "clean preloader::----------"
}

# 清除克隆项目的lk部分 
function clean_lk()
{
	echo "clean preloader::++++++++++"
	
	cd ${TOP_DIR}/${LK_PATH}
	echo $(pwd)
	
	rm project/${NEW_PROJECT}.mk
	rm -r target/${NEW_PROJECT}

	echo "clean preloader::----------"
}

# 清除克隆项目的kernel部分 
function clean_kernel()
{
	echo "clean kernel::++++++++++"
	
	cd ${TOP_DIR}/${KERNEL_PATH}
	echo $(pwd)

	rm -r drivers/misc/mediatek/mach/mt6735/${NEW_PROJECT}
	rm arch/arm64/configs/${NEW_PROJECT}_debug_defconfig
	rm arch/arm64/configs/${NEW_PROJECT}_defconfig
	rm arch/arm64/boot/dts/${NEW_PROJECT}.dts
	
	echo "clean kernel::----------"
}

# 清除克隆项目的android部分
function clean_android()
{
	echo "clean android::++++++++++"
	
	cd ${TOP_DIR}
	echo $(pwd)
	
	rm -r device/maisui/${NEW_PROJECT}
	rm -r vendor/mediatek/proprietary/custom/${NEW_PROJECT} 
	rm vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk

	rm -r vendor/wheatek/${NEW_PROJECT}

	echo "clean android::----------"
}

# 清除一个克隆的项目
function clean()
{
	echo "clean ::++++++++++"

	clean_pl
	clean_lk
	clean_kernel
	clean_android	

	echo "clean ::----------"
}


# 命令解析


# 获取当前目录和顶层目录
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR="$( cd .. && pwd)"
echo "TOP DIR = $CUR_DIR"
echo "BASE DIR = $TOP_DIR"

# 获取参数列表
echo "arg num = $#"
echo "args = $@"

if [[ $# -eq 3 ]] && [[ $1 == "clone" ]]; then
	BASE_PROJECT=$2
	NEW_PROJECT=$3

	echo "base_project = $BASE_PROJECT"
	echo "new_project = $NEW_PROJECT"
	
	# 启动克隆项目
	clone

elif [[ $# -eq 2 ]] && [[ $1 == "clean" ]]; then
	NEW_PROJECT=$2
	echo "new_project = $NEW_PROJECT"
	
	# 启动清除项目
	clean

else
	echo "arg errors"
	show_help
	exit -1

fi





