#! /bin/bash
#dumps each of the lmbench data sets
result="/home/Linux-version-test-result/Linux-test-result"
RESULTDIR="/mnt/results/default/lmbench/results"
#echo "# PERFORMANCE TEST RESULT" >>$result
lmbench() {
grep "hostA" $RESULTDIR/summary.txt > cache1.data
gcc lmbench.c
./a.out cache1.data >> cache.data
rm cache1.data
NUM=`cat cache.data | wc -l`
Type=`echo "$NUM / 11" | bc`

echo -e "## Lmbench-Performance Test of Kernel \n" >> $result
for i in `seq 11`
do
    N=`expr $i - 1`
    row=`expr $N \* $Type  + 1`
    col=`expr $row + $Type - 1`
    case $i in
        1)
        echo -e "### Processor, Processes - times in microseconds - smaller is better\n" >>$result
        echo "*Item* | *null call* | *null I/O* | *stat* | *open clos* | *slct TCP* | *sig inst* | *sig hndl* | *fork proc* | *exec proc* | *sh proc* " >> $result        
        echo "------ | ----------- | ---------- | ------ | ----------- | ---------- | ---------- | ---------- | ----------- | ----------- | --------- " >> $result
        N1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`  
        echo -e "**Average** | $N1\n" >>$result
	;;
        2)
        echo -e "### Basic integer operations - times in nanoseconds - smaller is better\n" >> $result
        echo "*Item* | *intgr bit* | *intgr add* | *intgr mul* | *intgr div* | *intgr mod* ">>$result
        echo "------ | ----------- | ----------- | ----------- | ----------- | ----------- " >> $result
        N2=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N2\n" >> $result
        ;;
        3)
        echo -e "### Basic uint64 operations - times in nanoseconds - smaller is better\n" >> $result
        echo "*Item* | *int64 bit* | *int64 add* | *int64 mul* | *int64 div* | *int64 mod* " >>$result
        echo "------ | ----------- | ----------- | ----------- | ----------- |------------ " >> $result
        N3=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' | awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N3\n" >> $result
        ;;     
        4)
        echo -e "### Basic float operations - times in nanoseconds - smaller is better\n " >> $result
        echo "*Item* |*float add* | *float mul* | *float div* | *float bogo*" >> $result
        echo "------ |----------- |------------ |------------ |-------------" >> $result
        N4=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N4\n" >> $result
        ;;
        5)
        echo -e "### Basic double operations - times in nanoseconds - smaller is better\n " >> $result
        echo "*Item* |*double add* | *double mul* | *double div* | *double bogo*" >> $result
        echo "------ |------------ | ------------ | ------------ | -------------" >> $result
        N5=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N5\n" >> $result
        ;;
        6)
        echo -e "### Context switching - times in microseconds - smaller is better\n" >> $result
        echo "*Item* | *2p/0K ctxsw* | *2p/16K ctxsw* | *2p/64K ctxsw* | *8p/16K ctxsw* | *8p/64K ctxsw* | *16p/16K ctxsw* | *16p/64K ctxsw*" >> $result
        echo "------ | ------------- | -------------- | -------------- | -------------- | -------------- | --------------- | ---------------" >> $result
        N6=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N6 \n" >> $result
        ;;
        7)
        echo -e "### \*Local\* Communication latencies in microseconds - smaller is better\n" >> $result
        echo "*Item* | *2p/0K ctxsw* | *Pipe* | *AF UNIX* | *UDP* | *RPC/UDP* | *TCP* | *RPC/TCP* | *TCP conn*" >> $result
        echo "------ | ------------- | ------ | --------- | ----- | --------- | ----- | --------- | ----------" >> $result
        N7=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            echo -e "**Average** | $N7 \n" >> $result
        ;;
        8)
        echo -e "### \*Remote\* Communication latencies in microseconds - smaller is better\n " >> $result
        echo " *Item* | *UDP* | *RPC/UDP* | *TCP* | *RPC/TCP* | *TCP conn* " >> $result
        echo " ------ | ----- | --------- | ----- | --------- | ----------  " >>$result
        N8=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average**| $N8\n" >> $result
        ;;
        9)
        echo -e "### File & VM system latencies in microseconds - smaller is better\n" >> $result
        echo " *Item* | *0K File Create* | *0K File Delete* | *10K File Create* | *10K File Delete* | *Mmap Latency* | *Prot Fault* | *Page Fault* | *100fd selct*" >> $result
        echo " ------ | ---------------- | ---------------- | ----------------- | ----------------- | -------------- | ------------ | ------------ | ------------" >>$result
        N9=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $N9\n" >> $result
        ;;
        10)
        echo -e "### \*Local\* Communication bandwidths in MB/s - bigger is better \n" >> $result
        echo " *Item* | *Pipe* | *AF UNIX* | *TCP* | *File reread* | *Mmap reread* | *Bcopy(libc)* | *Bcopy(hand)* | *Mem read* | *Mem write*" >>$result
        echo " ------ | ------ | --------- | ----- | ------------- | ------------- | ------------- | ------------- | ---------- | -----------" >>$result
        NA0=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $NA0 \n" >> $result
        ;;
        11)
        echo -e "### Memory latencies in nanoseconds - smaller is better\n" >> $result
        echo " *Item* | *L1 \$* |  *L2 \$* | *Main mem* | *Rand mem* | *Guesses*" >> $result
        echo " ------ | ------- | -------- | ---------- | ---------- | --------" >>$result
        NA1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
        echo -e "**Average** | $NA1 | \n" >> $result
        ;;
    esac
done
rm cache.data
}
lmbench
