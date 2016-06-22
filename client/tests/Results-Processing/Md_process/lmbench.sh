#!/bin/bash
#by lp

OSDIR=$1
TYPE=$2
LMBENCHDIR="Source_data/$OSDIR/default/lmbench/results"

lmbench() {
    grep "hostA" $LMBENCHDIR/summary.txt > cache1.data
    gcc Md_process/lmbench.c >/dev/null 2>&1
    ./a.out cache1.data >> cache.data
    rm a.out
    rm cache1.data
    NUM=`cat cache.data | wc -l`
    Type=`echo "$NUM / 11" | bc`

    for i in `seq 11`
    do
        N=`expr $i - 1`
        row=`expr $N \* $Type  + 1`
        col=`expr $row + $Type - 1`
        case $i in
            1)
                N1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`  
	    ;;
            2)
                N2=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            3)
                N3=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' | awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;     
            4)
                N4=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            5)
                N5=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            6)
                N6=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            7)
                N7=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            8)
                N8=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            9)
                N9=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            10)
                NA0=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            11)
                NA1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR"| ";print""}'`
            ;;
            esac
    done
    rm cache.data
    case $TYPE in
        PROCESS)
            echo "**$OSDIR** | $N1"
        ;;
        INT)
            echo "**$OSDIR** | $N2"     
        ;;
        UINT)
            echo "**$OSDIR** | $N3"
        ;;
        FLOAT)
            echo "**$OSDIR** | $N4"
        ;;
        DOUBLE)
            echo "**$OSDIR** | $N5"
        ;;
        CONTEXT)
            echo "**$OSDIR** | $N6"
        ;;
        LATENCY)
            echo "**$OSDIR** | $N7"
        ;;
        REMOTE)
            echo "**$OSDIR** | $N8"
        ;;
        FILEVM)
            echo "**$OSDIR** | $N9"
        ;;
        BANDWIDTH)
            echo "**$OSDIR** | $NA0"
        ;;
        MEMORY)
            echo "**$OSDIR** | $NA1"
        ;;
        esac
}
lmbench
