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
    itemsnum=`grep "8388608      32" $IOZONEDIR/raw_output_* | awk '{print NF}' | head -n 1`
    if [ $testnum -gt 1 ]
    then
        itemnum=`echo "$itemsnum - 3" | bc `
        tempnum=4
    else
        itemnum=`echo "$itemsnum - 2" | bc `
        tempnum=3
    fi
    echo -n "        ('$OSDIR', ["
    for((i=0; i<$itemnum; i++))
    do 
        j=$(($i+$tempnum))
        temp=`grep "8388608      32" $IOZONEDIR/raw_output_* |awk '{printf $'$j' "|";printf "\n"}' | awk '{for(n=1;n<=NF;n++)t[n]+=$n}END{for(n=1;n<=NF;n++)printf t[n]/NR;print" "}'`
        echo  -n "[$i, $temp], "   
    done
    echo -e "[$itemnum, 0]]),"
}
iozone
