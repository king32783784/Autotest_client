#!/bin/bash 
#sysbench 
#by lp 

OSDIR=$1
TYPE=$2
SYSMEMDIR="Source_data/$OSDIR/default/sysbench.mem/results"
PRIME1=10000
PRIME2=20000
PRIME3=30000
THREAD1=4
THREAD2=8
memaverage1()
{
    SUM=0
    for((i=1;i<=3;i++))
    do 
        MEM=`grep "Operations performed:" $SYSMEMDIR/raw_output_"$1"_$i | awk '{print $4}' | tr -d "("`
        SUM=`echo "scale=3;$SUM + $MEM" | bc `
    done
    AVG=`echo "scale=3;$SUM / 3" | bc `
    echo $AVG
}
memaverage2()
{
    SUM=0
    for((i=1;i<=3;i++))
    do
        MEM=`grep "transferred" $SYSMEMDIR/raw_output_"$1"_$i |awk '{print $4}' | tr -d "("`
        SUM=`echo "scale=3;$SUM + $MEM" | bc `
    done
    AVG=`echo "scale=3;$SUM / 3 " |bc`
    echo $AVG
}
memsysbench()
{
    MEM1=`memaverage1 $THREAD1`
    MEM2=`memaverage2 $THREAD1`
    MEM3=`memaverage1 $THREAD2`
    MEM4=`memaverage2 $THREAD2`
    if [ "$TYPE" == "MEMA" ];then
        echo "**$OSDIR** | $MEM1 | $MEM3 |"
    else
        echo "**$OSDIR** | $MEM2 | $MEM4 |"
    fi
}
memsysbench

