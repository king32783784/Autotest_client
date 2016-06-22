#!/bin/bash 
#neteprf 
#by lp 

OSDIR=$1
TYPE=$2
NETPERFDIR="Source_data/$OSDIR/default/netperf2/results"
netaverage1()
{
    TYPE=$1
    NUM=`ls $NETPERFDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $NETPERFDIR/netperf_output_"$TYPE"_"$i" | awk '{print $5}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}

netaverage2()
{
    TYPE=$1
    NUM=`ls $NETPERFDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $NETPERFDIR/netperf_output_"$TYPE"_"$i" | awk '{print $4}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}

netaverage3()
{
    TYPE=$1
    NUM=`ls $NETPERFDIR | grep "$1" | wc -l`
    SUM=0
    for (( i=1;i<=$NUM;i++))
    do
       NETNUM=`sed -n "7 p" $NETPERFDIR/netperf_output_"$TYPE"_"$i" | awk '{print $6}'`
       SUM=`echo "scale=2;$SUM + $NETNUM" | bc`
    done
    AVERAGE=`echo "scale=2;$SUM / $NUM" | bc`
    echo $AVERAGE
}
netperf()
{
    TCPSTREAM=`netaverage1 TCP_STREAM`
    UDPSTREAM=`netaverage2 UDP_STREAM`
    TCPRR=`netaverage3 TCP_RR`
    TCPCRR=`netaverage3 TCP_CRR`
    if [ $TYPE == "STREAM" ]
    then
        echo  "**$OSDIR** | $TCPSTREAM | $UDPSTREAM |"
    else
        echo "**$OSDIR** | $TCPRR | $TCPCRR |"
    fi
}
netperf
