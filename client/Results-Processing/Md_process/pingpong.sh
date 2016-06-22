#!/bin/sh
#by lp

OSDIR=$1
TYPE=$2
UNIXDIR="Source_data/$OSDIR/default/pingpong/results"
N1=4
N2=6
N3=8

dataprocessing()
{
    DN1=`echo "$N1 * 2" | bc` 
    DN2=`echo "$N2 * 2" | bc` 
    DN3=`echo "$N3 * 2" | bc` 
    TDN1=`grep "$DN1 threads initialised" $UNIXDIR/pingpong_results_*/pingpong*/*output  | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    TDN2=`grep "$DN2 threads initialised" $UNIXDIR/pingpong_results_*/pingpong*/*output | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    TDN3=`grep "$DN3 threads initialised" $UNIXDIR/pingpong_results_*/pingpong*/*output | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    GDN1=`grep "$N1 games completed" $UNIXDIR/pingpong_results_*/pingpong*/*output | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    GDN2=`grep "$N2 games completed" $UNIXDIR/pingpong_results_*/pingpong*/*output | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    GDN3=`grep "$N3 games completed" $UNIXDIR/pingpong_results_*/pingpong*/*output | awk '{print $5}' |  awk '{sum+=$1} END {printf "%.2f", sum/NR}'`
    if [ $TYPE == "THREADS" ];then    
        echo "**$OSDIR** | $TDN1 | $TDN2 | $TDN3|"
    else
        echo "**$OSDIR** | $GDN1 | $GDN2 | $GDN3|"
    fi 
}
dataprocessing     
