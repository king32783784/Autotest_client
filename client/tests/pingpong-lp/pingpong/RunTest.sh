#!/bin/sh 
#This script is created by lp  in order to make pingpong test easily. 
#Set times this test will be conducted, one should adjust this parameter by 
#provided its value  with command line such as "./Runtest num". The default value of it is 3. 
HOME=`pwd` 
pingresult="pingpong.log"
PINGPONGRESULT="/home/Linux-version-test-result/Linux-test-result"
#set test num threads 
if [ "$1" = "client" ];then
    N1=16
    N2=32
    N3=64
elif [ "$1" = "server" ];then
    N1=64
    N2=128
    N3=256
fi
echo $N1

#Remove old runnable pp32 
[ -f $pingresult ] && rm -r $pingresult
[ -f pp32 ] && rm -f pp32 


#Compile pp32 
gcc -pthread -O2 pp32.c -o pp32 


function table { 
    GAME_NUM=$1 
    { 
        ./pp32 -v -n $GAME_NUM -i 100000 
        ./pp32 -v -n $GAME_NUM -i 100000 
        ./pp32 -v -n $GAME_NUM -i 100000 
        ./pp32 -v -n $GAME_NUM -i 100000 
        ./pp32 -v -n $GAME_NUM -i 100000 

    } >> $pingresult
    sleep 3 
} 

#Run test 
RUN_TIMES=3 
i=1 
while [ $i -le $RUN_TIMES ] ; do 
    table $N1 
    table $N2 
    table $N3 
    i=`expr $i + 1` 
done 
#Data process
dataprocessing()
{
    DN1=`echo "$N1 * 2" | bc` 
    DN2=`echo "$N2 * 2" | bc` 
    DN3=`echo "$N3 * 2" | bc` 
    echo -e "##  Pingpong - Performance Test of Threads\n" >> $PINGPONGRESULT
    echo -e "Threads initialised - times in microseconds - smaller is better\n" >> $PINGPONGRESULT
    echo "*Item* | *Tables $N1* | *Tables $N2* | *Tables $N3* " >> $PINGPONGRESULT
    echo "------ | ------------- | ------------- | ------------" >> $PINGPONGRESULT
    TDN1=`grep "$DN1 threads initialised" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    TDN2=`grep "$DN2 threads initialised" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    TDN3=`grep "$DN3 threads initialised" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    echo -e "**Averages** $TDN1 $TDN2 $TDN3 \n" >> $PINGPONGRESULT
    echo -e "Games completed - times in microseconds - smaller is better \n" >> $PINGPONGRESULT
    echo "*Item* | *Tables $N1* | *Tables $N2* | *Tables $N3* " >> $PINGPONGRESULT
    echo "------ | ------------ | ------------ | ------------ " >> $PINGPONGRESULT
    GDN1=`grep "$N1 games completed" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    GDN2=`grep "$N2 games completed" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    GDN3=`grep "$N3 games completed" pingpong.log | awk '{print $5}' |  awk '{sum+=$1} END {printf "| %.2f", sum/NR}'`
    echo -e "**Averages** $GDN1 $GDN2 $GDN3 \n" >> $PINGPONGRESULT
}
dataprocessing     
rm $pingresult     
