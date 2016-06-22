#!/bin/bash
UNIXRESULT="/mnt/results/default/unixbench5/results"
unixresult="/home/Linux-version-test-result/Linux-test-result"
unixbench()
{
    echo -e "## Unixbench - Performance Test of System Standard\n" >> $unixresult
    echo -e "### System Benchmarks Index Score\n" >> $unixresult
    echo "*Item* | *Single thread* | *Multi threads*" >> $unixresult
    echo "------ | --------------- | ---------------" >> $unixresult
    SINGLE=`awk '$4=="Score" {print $5}' $UNIXRESULT/raw_output_* | awk 'NR%2==1'|  awk '{sum+=$1} END {print " ", sum/NR}'`
    MULTI=`awk '$4=="Score" {print $5}' $UNIXRESULT/raw_output_* | awk 'NR%2==0'|  awk '{sum+=$1} END {print " ", sum/NR}'`
    echo -e "**Average** | $SINGLE | $MULTI|\n" >> $unixresult

    ED=`awk '$1=="2D" && $5=="Score" {print $6}' $UNIXRESULT/raw_output_* | awk '{sum+=$1} END {print " ", sum/NR}'`
    SD=`awk '$1=="3D" && $5=="Score" {print $6}' $UNIXRESULT/raw_output_* | awk '{sum+=$1} END {print " ", sum/NR}'`
    echo -e "### Graphics Benchmarks Index Score\n" >> $unixresult
    echo "*Item* | *2D* | *3D*" >> $unixresult
    echo "------ | ---- | ----" >> $unixresult
    echo -e "**Average** |$ED |$SD|\n" >> $unixresult
}
unixbench
