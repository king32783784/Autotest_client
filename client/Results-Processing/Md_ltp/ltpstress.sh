#! /bin/bash 
#by lp
testtime=72
type=$1
if [ $type = "FAIL" ]
then
    LTPOS=($@)
    LTPOS=(${LTPOS[@]:0:0} ${LTPOS[@]:1})
    osnum=${#LTPOS[@]}
else
    LTPOS=$2
fi
status()
{
    PASSNUM=`grep PASS Source_data/$LTPOS/default/ltp_stress/results/ltp.log | wc -l`
    FAILNUM=`grep FAIL Source_data/$LTPOS/default/ltp_stress/results/ltp.log | wc -l`
    FAILED=`grep FAIL Source_data/$LTPOS/default/ltp_stress/results/ltp.log |sort|uniq| wc -l`
    TOTALNUM=`echo "$PASSNUM + $FAILNUM " | bc `
    EFFICIENCY=`echo "$TOTALNUM / $testtime" | bc `
    RATETMP=`echo " scale=4;$PASSNUM / $TOTALNUM" | bc `
    RATE=`echo "scale=2;$RATETMP * 100 / 1 "|bc `
    echo  "$LTPOS | $TOTALNUM | $EFFICIENCY | $FAILNUM | $FAILED |  $PASSNUM | $RATE%" 
}

system()
{
    CPULOAD=`echo "100 - $(sar -u -f Source_data/$LTPOS/default/ltp_stress/results/sar.out  | tail -1 | awk '{print $8}')" | bc`
    MEMLOAD=`sar -r -f Source_data/$LTPOS/default/ltp_stress/results/sar.out | tail -1 | awk '{print $4}'`
    SWAPLOAD=`sar -S -f Source_data/$LTPOS/default/ltp_stress/results/sar.out | tail -1 | awk '{print $4}'`
    Ldavg1=`sar -q -f Source_data/$LTPOS/default/ltp_stress/results//sar.out | tail -1 | awk '{print $4}'`
    Ldavg5=`sar -q -f Source_data/$LTPOS/default/ltp_stress/results//sar.out | tail -1 | awk '{print $5}'`
    Ldavg15=`sar -q -f Source_data/$LTPOS/default/ltp_stress/results/sar.out | tail -1 | awk '{print $6}'`
    echo  "$CPULOAD% | $MEMLOAD% | $SWAPLOAD% | $Ldavg1% | $Ldavg5% | $Ldavg15%"
}

fail()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep FAIL Source_data/$OSNAME/default/ltp_stress/results/ltp.log |sort|uniq |wc -l`
        [[ $LTPNUM -gt $MAX ]]&&MAX=$LTPNUM
    done
    if [[ $MAX -gt 0 ]]
    then
        echo -e "### Fail Case List \n" >> ltpmd
        echo -n "*NUM* | " >> ltpmd
        osnum1=$(($osnum-1))
        for((i=0;i<$osnum1;i++))
        do
            OSNAME=${LTPOS[$i]}
            echo -n "$OSNAME | " >> ltpmd
        done
        echo "${LTPOS[$osnum1]}" >> ltpmd
        for((i=0;i<$osnum;i++))
        do
            echo -n "-------- |" >> ltpmd
        done
        echo "------- | " >> ltpmd
        num=1
        while [ $num -le $MAX ];do
            echo -n "$num | " >> ltpmd
            for((i=0;i<$osnum1;i++))
            do
                OSNAME=${LTPOS[$i]}
                CASENAME=`grep FAIL Source_data/$OSNAME/default/ltp_stress/results/ltp.log |sort|uniq | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
                CASENAME=`grep FAIL Source_data/$OSNAME/default/ltp_stress/results/ltp.log |sort|uniq | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME " >> ltpmd
            num=$(($num + 1))
        done
    else
        echo "" >>ltpmd
    fi
}
main()
{
    case $type in
        STATUS)
            status=`status`
            echo $status
        ;;
        SYSTEM)
            system=`system`
            echo $system
        ;;
        FAIL)
            fail
        ;;
        esac
}
main
