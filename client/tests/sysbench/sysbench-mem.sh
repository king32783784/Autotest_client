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
memsysbench()
{
    echo -e "### Sysbench - Test of MEM\n" >> $SYSRESULT
    echo -e "MEM Operations performed & Transfer rate - 4threads & 8 threads -bigger is better\n" >> $SYSRESULT
    echo "*Item* | *4threads(ops/sec)* | *4threads(MB/sec)* | *8threads(ops/sec)* | *8threads(MB/sec)* " >> $SYSRESULT
    echo "------ | ------------------- | ------------------ | ------------------- | ------------------ " >>$SYSRESULT
    MEM1=`memaverage1 $THREAD1`
    MEM2=`memaverage2 $THREAD1`
    MEM3=`memaverage1 $THREAD2`
    MEM4=`memaverage2 $THREAD2`
    echo -e "**Average** | $MEM1 | $MEM2 | $MEM3 | $MEM4|\n" >> $SYSRESULT
}
memsysbench

