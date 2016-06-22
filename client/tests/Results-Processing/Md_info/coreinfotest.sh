#!/bin/bash
#by lp

SYSINFOOS=($@)
osnum=${#SYSINFOOS[@]}
title()
{
    echo -n "*Item* | " >> coreinfo
    osnum1=$(($osnum-1))
    for((i=0;i<$osnum1;i++))
    do
        OSNAME=${SYSINFOOS[$i]} 
        echo -n "$OSNAME | " >> coreinfo
    done
    echo  "${SYSINFOOS[$osnum1]}"  >> coreinfo
    for((i=0;i<$osnum;i++))
    do
        echo -n " -------- |" >> coreinfo
    done
    echo "--------- | " >> coreinfo
    for((i=0;i<=$osnum;i++))
    do
        SYSOS=${SYSINFOOS[$i]}
        SYSINFODIR[$i]="Source_data/$SYSOS/default/infotest/results/coreinfo"
    done

    for((i=1;i<$osnum;i++))
    do  
        j=$(($i-1))
        SYSOSA=${SYSINFODIR[$j]}
        SYSOSB=${SYSINFODIR[$i]}
        join $SYSOSA $SYSOSB  > temp$i
        SYSINFODIR[$i]="./temp$i"          
    done
    k=$(($i-1))
    cat ./temp$k >> coreinfo
    rm -rf temp*
}
title
