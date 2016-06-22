#! /bin/bash 
#This script is created by lp  in order to make ltpstress test easily. 
LTPLOG="/mnt/results/default/ltp/results"
ltpresult="/home/Linux-version-test-result/Linux-test-result"
ltprun()
{   
    echo -e "## Ltp - Function Test of Kernel Basic \n" >>$ltpresult 
    echo -e "### Ltp-runltp Test Overall Status \n" >>$ltpresult
    echo "*Total Cases* | *Pass Cases* | *Fail Cases* | *Conf Cases* | *Brok Cases* | *Warn Cases* | *Info Cases*" >>$ltpresult
    echo "------------- | ------------ | ------------ | ------------ | ------------ | ------------ | ------------" >>$ltpresult
    PASSNUM=`grep PASS $LTPLOG/ltp.log | wc -l`
    FAILNUM=`grep FAIL $LTPLOG/ltp.log | wc -l`
    CONFNUM=`grep CONF $LTPLOG/ltp.log | wc -l`
    BROKNUM=`grep BROK $LTPLOG/ltp.log | wc -l`
    WARNNUM=`grep WARN $LTPLOG/ltp.log | wc -l`
    INFONUM=`grep INFO $LTPLOG/ltp.log | wc -l`
    TOTALNUM=`echo "$PASSNUM + $FAILNUM + $CONFNUM + $BROKNUM + $WARNNUM + $INFONUM " | bc `
    echo -e "$TOTALNUM | $PASSNUM | $FAILNUM | $CONFNUM | $BROKNUM | $WARNNUM | $INFONUM\n" >>$ltpresult

## FAIL cases
    if grep FAIL $LTPLOG/ltp.log >/dev/null 2>&1
    then
        echo -e "### Fail Case List \n" >> $ltpresult
        echo "*NO.* | *Case Name* | *Exit Value* " >> $ltpresult
        echo "----- | ----------- | ------------ " >> $ltpresult
        num=1
        while [ $num -le $FAILNUM ];do
            CASENAME=`grep FAIL $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $1}'`
            EXIT=`grep FAIL $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $3}'`
            printf "%-20d | %10s | %24d \n" $num $CASENAME $EXIT >> $ltpresult
            num=$(($num + 1))
        done  
        echo -e "\n" >> $ltpresult
    fi
    
## CONF cases
    if grep CONF $LTPLOG/ltp.log >/dev/null 2>&1
    then
        echo -e "### Conf Case List \n" >> $ltpresult
        echo "*No.* | *Case Name* | *Exit Value*" >> $ltpresult
        echo "----- | ----------- | ------------" >> $ltpresult
        num=1
        while [ $num -le $CONFNUM ];do
            CASENAME=`grep CONF $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $1}'`
            EXIT=`grep CONF $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $3}'`
            printf "%-20d | %10s | %24d \n" $num $CASENAME $EXIT >> $ltpresult
            num=$(($num + 1))
        done 
        echo -e "\n" >> $ltpresult
    fi
## BROK cases
    if grep BROK $LTPLOG/ltp.log >/dev/null 2>&1
    then
        echo -e "### BROK Case List \n" >> $ltpresult
        echo "*No.* | *Case Name* | *Exit Value*" >> $ltpresult
        echo "----- | ----------- | ------------" >> $ltpresult
        num=1
        while [ $num -le $BROKNUM ];do
            CASENAME=`grep BROK $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $1}'`
            EXIT=`grep BROK $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $3}'`
            printf "%-20d | %10s | %24d \n" $num $CASENAME $EXIT >> $ltpresult
            num=$(($num + 1))
        done
        echo -e "\n" >> $ltpresult
    fi

## WARN cases
    if grep WARN $LTPLOG/ltp.log > /dev/null 2>&1
    then
        echo -e "### WARN Case List \n" >> $ltpresult
        echo "*No.* | *Case Name* | *Exit Value*" >> $ltpresult
        echo "----- | ----------- | ------------" >> $ltpresult
        num=1
        while [ $num -le $WARNNUM ] ;do
            CASENAME=`grep WARN $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $1}'`
            EXIT=`grep BROK $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $3}'`
            print "%-20d | %10s | %24d \n" $num $CASENAME $EXIT >> $ltpresult
            num=$(($num + 1))
        done
        echo -e "\n" >> $ltpresult
    fi

## INFO cases
    if grep INFO $LTPLOG/ltp.log > /dev/null 2>&1
    then
        echo -e "### INFO Case List \n" >> $ltpresult
        echo "*No.* | *Case Name* | *Exit Value*" >> $ltpresult
        echo "----- | ----------- | ------------" >> $ltpresult
        num=1
        while [ $num -le $INFONUM ] ;do
            CASENAME=`grep INFO $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $1}'`
            EXIT=`grep INFO $LTPLOG/ltp.log | sed -n "$num p" | awk '{print $3}'`
            print "%-20d | %10s | %24d \n" $num $CASENAME $EXIT >> $ltpresult
            num=$(($num + 1))
        done
        echo -e "\n" >> $ltpresult
    fi

}
ltprun
