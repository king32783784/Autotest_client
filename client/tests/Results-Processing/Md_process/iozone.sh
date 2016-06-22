#!/bin/bash
#Wrote by lp

OSDIR=$1
IOZONEDIR="Source_data/$OSDIR/default/iozone/results"
TESTS=8
TESTBITE=32
TESTSBITE=`echo "$TESTS * 1024 * 1024" | bc`
iozone()
{
    testnum=`ls $IOZONEDIR/raw_output_* | wc -l`
    if [ $testnum -gt 1 ]
    then
        tempnum=4
    else
        tempnum=3
    fi 
    IO=`grep "8388608      32" $IOZONEDIR/raw_output_* |awk '{for(j='$tempnum';j<=NF;j++)printf $j" ";printf "\n"}' |awk '{for(n=0;n<=NF;n++)t[n]+=$n}END{for(n=1;n<=NF;n++)printf t[n]/NR"| ";print""}'`
    echo  "**$OSDIR** |$TESTSBITE | $TESTBITE | $IO"
}
iozone
