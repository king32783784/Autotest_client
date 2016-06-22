#!/bin/bash
#This script is created by LP in order to test the netperf performance easily.
#Howto:sh netperf-performance ; Please enter right message follow the help info.
result="/home/Linux-version-test-result/Linux-test-result"
RESULTDIR="/mnt/results/default/netperf2/results"
netaverage1()
{
    TYPE=$1
    NUM=`ls $RESULTDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $RESULTDIR/netperf_output_"$TYPE"_"$i" | awk '{print $5}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}

netaverage2()
{
    TYPE=$1
    NUM=`ls $RESULTDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $RESULTDIR/netperf_output_"$TYPE"_"$i" | awk '{print $4}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}

netaverage3()
{
    TYPE=$1
    NUM=`ls $RESULTDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $RESULTDIR/netperf_output_"$TYPE"_"$i" | awk '{print $6}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}
netperf()
{
    echo -e "## Netperf - Performance Test of Net \n" >> $result
    echo -e "Tcp、Udp-Throughput & Request/Response bigger is better \n" >> $result
    echo "*Item* | *TCP STREAM(10^6bits/sec)* | *UDP STREAM(10^6bits/sec)* | *TCP RR* | *TCP CRR*" >> $result
    echo "------ | ------------ | ------------ | -------- | -------- " >> $result
    TCPSTREAM=`netaverage1 TCP_STREAM`
    UDPSTREAM=`netaverage2 UDP_STREAM`
    TCPRR=`netaverage3 TCP_RR`
    TCPCRR=`netaverage3 TCP_CRR`
    echo -e "**Average** | $TCPSTREAM | $UDPSTREAM | $TCPRR | $TCPCRR \n" >> $result
}
netperf
