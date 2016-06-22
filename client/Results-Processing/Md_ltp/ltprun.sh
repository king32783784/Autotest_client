#! /bin/bash 
#by lp

type=$1
if [ $type = "OVERALL" ]
then
    LTPOS=$2
else
    LTPOS=($@)
    LTPOS=(${LTPOS[@]:0:0} ${LTPOS[@]:1})
    osnum=${#LTPOS[@]}
fi
##OVERALL
overall()
{
    PASSNUM=`grep PASS Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    FAILNUM=`grep FAIL Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    CONFNUM=`grep CONF Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    BROKNUM=`grep BROK Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    WARNNUM=`grep WARN Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    INFONUM=`grep INFO Source_data/$LTPOS/default/ltp/results/ltp.log | wc -l`
    TOTALNUM=`echo "$PASSNUM + $FAILNUM + $CONFNUM + $BROKNUM + $WARNNUM + $INFONUM " | bc `
    echo  "$LTPOS | $TOTALNUM | $PASSNUM | $FAILNUM | $CONFNUM | $BROKNUM | $WARNNUM | $INFONUM" 
}
## FAIL cases
fail()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep FAIL Source_data/$OSNAME/default/ltp/results/ltp.log | wc -l`
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
                CASENAME=`grep FAIL Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
            CASENAME=`grep FAIL Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME | " >> ltpmd 
            num=$(($num + 1))
        done  
    else
        echo "" >>ltpmd
    fi
}    
## CONF cases
conf()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep CONF Source_data/$OSNAME/default/ltp/results/ltp.log | wc -l`
        [[ $LTPNUM -gt $MAX ]]&&MAX=$LTPNUM
    done
    if [[ $MAX -gt 0 ]]
    then
        echo -e "### Conf Case List \n" >> ltpmd
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
                CASENAME=`grep CONF Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
            CASENAME=`grep CONF Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME | " >> ltpmd
            num=$(($num + 1))
        done
    else
        echo "" >> ltpmd
    fi
}
## BROK cases
brok()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep BROK Source_data/$OSNAME/default/ltp/results/ltp.log | wc -l`
        [[ $LTPNUM -gt $MAX ]]&&MAX=$LTPNUM
    done
    if [[ $MAX -gt 0 ]]
    then
        echo -e "### Brok Case List \n" >> ltpmd
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
                CASENAME=`grep BROK Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
            CASENAME=`grep BROK Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME |  " >> ltpmd
            num=$(($num + 1))
        done
    else
        echo "" >> ltpmd
    fi
}
## WARN cases
warn()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep WARN Source_data/$OSNAME/default/ltp/results/ltp.log | wc -l`
        [[ $LTPNUM -gt $MAX ]]&&MAX=$LTPNUM
    done
    if [[ $MAX -gt 0 ]]
    then
        echo -e "### Warn Case List \n" >> ltpmd
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
                CASENAME=`grep WARN Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
            CASENAME=`grep WARN Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME  | " >> ltpmd
            num=$(($num + 1))
        done
    else
        echo "" >> ltpmd
    fi
}
## INFO cases
info()
{
    MAX=0
    for((i=0;i<$osnum;i++))
    do
        OSNAME=${LTPOS[$i]}
        LTPNUM=`grep BROK Source_data/$OSNAME/default/ltp/results/ltp.log | wc -l`
        [[ $LTPNUM -gt $MAX ]]&&MAX=$LTPNUM
    done
    if [[ $MAX -gt 0 ]]
    then
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
                CASENAME=`grep WARN Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
                echo -n "$CASENAME | " >> ltpmd
            done
            OSNAME=${LTPOS[$osnum1]}
            CASENAME=`grep WARN Source_data/$OSNAME/default/ltp/results/ltp.log | sed -n "$num p" | awk '{print $1}'`
            echo  "$CASENAME  | " >> ltpmd
            num=$(($num + 1))
        done
    else
        echo "" >> ltpmd
    fi
}
main()
{
    case $type in
        OVERALL)
            overall=`overall`
            echo $overall
        ;;
        FAIL)
            fail
        ;;
        CONF)
            conf
        ;;
        BROK)
            brok
        ;;
        WARN)
            warn
        ;;
        INFO)
            info
        ;;
        esac
}
main
