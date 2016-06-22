#!/bin/bash
#by lp

OSDIR=$1
TYPE=$2
UNIXDIR="Source_data/$OSDIR/default/unixbench5/results"

unixbench()
{
    SINGLE=`awk '$4=="Score" {print $5}' $UNIXDIR/raw_output_* | awk 'NR%2==1'|  awk '{sum+=$1} END {print " ", sum/NR}'`
    MULTI=`awk '$4=="Score" {print $5}' $UNIXDIR/raw_output_* | awk 'NR%2==0'|  awk '{sum+=$1} END {print " ", sum/NR}'`
    ED=`awk '$1=="2D" && $5=="Score" {print $6}' $UNIXDIR/raw_output_* | awk '{sum+=$1} END {print " ", sum/NR}'`
    SD=`awk '$1=="3D" && $5=="Score" {print $6}' $UNIXDIR/raw_output_* | awk '{sum+=$1} END {print " ", sum/NR}'`
 
    if [ "$TYPE" == "SYSTEM" ];then
        echo "('$OSDIR', [[0,$SINGLE], [1,$MULTI], [2,0]]),"
    else
        echo "('$OSDIR', [[0,$ED], [1,$SD], [2,0]]),"
    fi   
}
unixbench
