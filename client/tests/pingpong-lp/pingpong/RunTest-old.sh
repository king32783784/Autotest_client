#!/bin/sh

#This script is created by KC based on KongWei's script(Runtest.sh.old) in order to control the repeat times of this test easily.

#Set times this test will be conducted, one should adjust this parameter by
#provided its value  with command line such as "./Runtest num". The default value of it is 3.
if [ -z "$1" ] ; then
	RUN_TIMES=3
else
	RUN_TIMES=$1
fi

#Remove old runnable pp32
[ -f pp32 ] && rm -f pp32

#Compile pp32
gcc -pthread -O2 pp32.c -o pp32

function table {
	GAME_NUM=$1	
	{
		./pp32 -v -n $GAME_NUM -i 100000	
	 	./pp32 -v -n $GAME_NUM -i 100000	
	 	./pp32 -v -n $GAME_NUM -i 100000	
	 	./pp32 -v -n $GAME_NUM -i 100000	
	 	./pp32 -v -n $GAME_NUM -i 100000	
	 	./pp32 -v -n $GAME_NUM -i 100000	
	} > ${PP[$i]}/${GAME_NUM}output
	sleep 300
}

#Make directories to store results
i=1
while [ $i -le $RUN_TIMES ] ; do
	PP[$i]=/opt/pingpong_results_$(date +'%Y%m%d%H%M')/pingpong${i}
	[ -d ${PP[$i]} ] || mkdir -p ${PP[$i]}
	i=`expr $i + 1`
done

#Run test
i=1
while [ $i -le $RUN_TIMES ] ; do
	table 64
	table 128
	table 256
	i=`expr $i + 1`
done

exit 0
