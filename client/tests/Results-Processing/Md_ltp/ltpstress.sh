#! /bin/bash 
#This script is created by lp  in order to make ltpstress test easily. 
testtime=72
LTPLOG="/mnt/results/default/ltp_stress/results"
ltpresult="/home/Linux-version-test-result/Linux-test-result"
ltpstress()
{   
    echo -e "## Ltp - Stress Test of System \n" >>$ltpresult 
    echo -e "### Case Execution Status \n" >>$ltpresult
    echo "*Test Time* | *Total Num* | *Execution Efficiency* | *Fail Types* | *Pass-Total* | *Fail-Total* | *Success Rate* " >>$ltpresult
    echo "----------- | ----------- | ---------------- | ----------- | ------------ | ------------ | -------------- " >>$ltpresult
    PASSNUM=`grep PASS $LTPLOG/ltp.log | wc -l`
    FAILNUM=`grep FAIL $LTPLOG/ltp.log | wc -l`
    FAILED=`grep FAIL $LTPLOG/ltp.log |sort|uniq| wc -l`
    TOTALNUM=`echo "$PASSNUM + $FAILNUM " | bc `
    EFFICIENCY=`echo "$TOTALNUM / $testtime" | bc `
    RATETMP=`echo " scale=4;$PASSNUM / $TOTALNUM" | bc `
    RATE=`echo "scale=2;$RATETMP * 100 / 1 "|bc `
    echo -e " $testtime h | $TOTALNUM | $EFFICIENCY | $FAILED | $PASSNUM | $FAILNUM | $RATE%\n" >>$ltpresult

    echo -e "### System Load Status \n" >> $ltpresult
    echo "*CPU Utilization* | *MEM Utilization* | *SWAP Utilization* | *Ldavg-1* | *Ldavg-5* | *Ldavg-15* " >> $ltpresult
    echo "----------------- | ----------------- | ------------------ | --------- | --------- | ----------" >> $ltpresult
    CPULOAD=`echo "100 - $(sar -u -f $LTPLOG/sar.out  | tail -1 | awk '{print $8}')" | bc`
    MEMLOAD=`sar -r -f $LTPLOG/sar.out | tail -1 | awk '{print $4}'`
    SWAPLOAD=`sar -S -f $LTPLOG/sar.out | tail -1 | awk '{print $4}'`
    Ldavg1=`sar -q -f $LTPLOG/sar.out | tail -1 | awk '{print $4}'`
    Ldavg5=`sar -q -f $LTPLOG/sar.out | tail -1 | awk '{print $5}'`
    Ldavg15=`sar -q -f $LTPLOG/sar.out | tail -1 | awk '{print $6}'`
    echo -e "$CPULOAD% | $MEMLOAD% | $SWAPLOAD% | $Ldavg1% | $Ldavg5% | $Ldavg15%\n" >> $ltpresult

    echo -e "### FAIL Case Status\n" >>$ltpresult
    echo  "*Casename* | *Total-num* | *Fail-num*" >> $ltpresult
    echo  "---------- | ----------- | ---------- " >> $ltpresult 
    num=1
    while [ $num -le $FAILED ];do
        FAILCASE=`grep FAIL $LTPLOG/ltp.log |sort|uniq | sed -n "$num p" | awk '{print $1}'`
        FAILCASENUM1=`grep -w "$FAILCASE" $LTPLOG/ltp.log | wc -l `
        FAILCASENUM2=`grep -w "$FAILCASE" $LTPLOG/ltp.log | grep FAIL | wc -l`
        printf "%-20s |  %10d | %24d \n" $FAILCASE $FAILCASENUM1 $FAILCASENUM2 >> $ltpresult
        num=$(($num + 1))
    done  
    echo -e "\n" >> $ltpresult
}
ltpstress
