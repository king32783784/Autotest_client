#!/bin/bash 
#sysbench 
#howto:sh sysbench.sh 
#by lp 
SYSRESULT="/home/Linux-version-test-result/Linux-test-result"
HOME="/mnt/results/default"
PRIME1=10000
PRIME2=20000
PRIME3=30000
THREAD1=4
THREAD2=8
cpuaverage()
{
    SUM=0
    for ((i=1;i<=3;i++))
    do
        CPU=`grep "execution time" $HOME/sysbench.cpu/results/raw_output_"$1"_$i | awk '{print $4}' | cut -c 1-6`
        SUM=`echo "scale=3;$SUM + $CPU" | bc `
    done
    AVG=`echo "scale=3;$SUM / 3" | bc`
    echo $AVG
}
memaverage1()
{
    SUM=0
    for((i=1;i<=3;i++))
    do 
        MEM=`grep "Operations performed:" $HOME/sysbench.mem/results/raw_output_"$1"_$i | awk '{print $4}' | tr -d "("`
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
        MEM=`grep "transferred" $HOME/sysbench.mem/results/raw_output_"$1"_$i |awk '{print $4}' | tr -d "("`
        SUM=`echo "scale=3;$SUM + $MEM" | bc `
    done
    AVG=`echo "scale=3;$SUM / 3 " |bc`
    echo $AVG
}
cpusysbench()
{
    echo -e "## Sysbench - Performance Test of Result\n" >> $SYSRESULT
    echo -e "### Sysbench - Test of CPU\n" >> $SYSRESULT
    echo -e "CPU Execution time(second) - 1thread - smaller is better\n" >> $SYSRESULT
    echo "*Item* | *$PRIME1* | *$PRIME2* | *$PRIME3*" >> $SYSRESULT
    echo "------ | --------- | --------- | ---------" >> $SYSRESULT
    CPU1=`cpuaverage $PRIME1`
    CPU2=`cpuaverage $PRIME2`
    CPU3=`cpuaverage $PRIME3`
    echo -e "**Average** | $CPU1 | $CPU2 | $CPU3|\n" >> $SYSRESULT
}
cpusysbench

