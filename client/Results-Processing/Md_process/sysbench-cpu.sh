#!/bin/bash 
#sysbench 
#by lp 
OSDIR=$1
SYSCPUDIR="Source_data/$OSDIR/default/sysbench.cpu/results"

PRIME1=10000
PRIME2=20000
PRIME3=30000

cpuaverage()
{
    SUM=0
    for ((i=1;i<=3;i++))
    do
        CPU=`grep "execution time" $SYSCPUDIR/raw_output_"$1"_$i | awk '{print $4}' | cut -c 1-6`
        SUM=`echo "scale=3;$SUM + $CPU" | bc `
    done
    AVG=`echo "scale=3;$SUM / 3" | bc`
    echo $AVG
}

cpusysbench()
{
    CPU1=`cpuaverage $PRIME1`
    CPU2=`cpuaverage $PRIME2`
    CPU3=`cpuaverage $PRIME3`
    echo "**$OSDIR** | $CPU1 | $CPU2 | $CPU3|"
}
cpusysbench

