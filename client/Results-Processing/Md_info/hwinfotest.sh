#!/bin/bash
#by lp

SYSINFOOS=($@)
SYSINFODIR="Source_data/$SYSOS/default/infotest/results/"
osnum=${#SYSINFOOS[@]}
title()
{
    echo -n "*Item* | " >> hwinfo
    osnum1=$(($osnum-1))
    for((i=0;i<$osnum1;i++))
    do
        OSNAME=${SYSINFOOS[$i]} 
        echo -n "$OSNAME | " >> hwinfo
    done
    echo  "${SYSINFOOS[$osnum1]}"  >> hwinfo
    for((i=0;i<$osnum;i++))
    do
        echo -n " -------- |" >> hwinfo
    done
    echo "--------- | " >> hwinfo
    for((i=0;i<=$osnum;i++))
    do
        SYSOS=${SYSINFOOS[$i]}
        SYSINFODIR[$i]="Source_data/$SYSOS/default/infotest/results/hwinfo"
    done
    if [[ $osnum -gt 1 ]]
    then
        for((i=1;i<$osnum;i++))
        do  
            j=$(($i-1))
            SYSOSA=${SYSINFODIR[$j]}
            SYSOSB=${SYSINFODIR[$i]}
            join $SYSOSA $SYSOSB  > temp$i
            SYSINFODIR[$i]="./temp$i"          
        done
        k=$(($i-1))
        cat ./temp$k >> hwinfo
        rm -rf temp*
     else
         SYSOSA=${SYSINFODIR[0]}
         cat $SYSOSA >> hwinfo
     fi
}
title
