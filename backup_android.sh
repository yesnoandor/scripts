#!/bin/sh

# 压缩
function tar_gz()
{
	echo "tar gz::++++++++++"
	
	filter_dir $1
	##echo $?
	
	# 得到返回值作为res变量的值
	##res=`echo $?` 
	res=$(echo $?)	
	##echo "res = $res"

	if [ $res -eq 1 ]; then
		echo "folder $1 skipped!"
	else
		echo "tar -zcvf $1.tar.gz $1"
		#tar -zcvf $1.tar.gz $1
	fi

	echo "tar gz::----------"
}


# 过滤不压缩的目录
# 	=1,不需要压缩
#	=0,需要压缩
function filter_dir()
{
	echo "filter dir::++++++++++"
	
	readonly str=("out" "opt")

	for s in ${str[@]}
	do
		#echo $s

		if [ $s == $1 ] ; then
			echo "filter dir::----------"
			return 1
		fi
	done

	echo "filter dir::----------"
	
	return 0
}


# 获取当前目录和顶层目录
CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR="$( cd .. && pwd)"
echo "BASE DIR = $CUR_DIR"
echo "TOP DIR = $TOP_DIR"

cd ..

for cur_dirs in $(ls)
do
	if [ -d $cur_dirs ]
	then
		#echo $cur_dirs
		tar_gz $cur_dirs
	fi
done


