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
                N1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`  
	    ;;
            2)
                N2=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            3)
                N3=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' | awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;     
            4)
                N4=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            5)
                N5=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            6)
                N6=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            7)
                N7=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            8)
                N8=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            9)
                N9=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            10)
                NA0=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=3;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            11)
                NA1=`sed -n "${row},${col}p" cache.data |awk -F\| '{for(j=4;j<=NF;j++)printf $j+0" ";printf "\r\n"}' |  awk '{for(n=0;n<NF;n++)t[n]+=$n}END{for(n=1;n<NF;n++)printf t[n]/NR" ";print""}'`
            ;;
            esac
    done
    rm cache.data
    case $TYPE in
        PROCESS1) 
            echo -n "        ('$OSDIR', ["
            num=`echo "$N1" | wc -w`
            num1=$(($num-3))
            for((i=0; i<$num1; i++))
            do 
                j=$(($i+1))
                temp=`echo "$N1" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num1, 0]]),"
        ;;
        PROCESS2)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N1" | wc -w`
            num1=$(($num-2))
            for((i=0; i<3; i++))
            do
                j=$num1
                temp=`echo "$N1" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[4, 0]]),"
        ;;
        INT)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N2" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N2" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"                 
        ;;
        UINT)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N3" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N3" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"
        ;;
        FLOAT)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N4" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N4" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"
        ;;
        DOUBLE)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N5" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N5" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"
        ;;
        CONTEXT)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N6" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N6" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0], [$(($num+1)),0]]),"
        ;;
        LATENCY)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N7" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N7" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0], [$(($num+1)),0]]),"
        ;;
        REMOTE)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N8" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N8" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"
        ;;
        FILEVM)
            echo -n "        ('$OSDIR', ["
            num=`echo "$N9" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$N9" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0], [$(($num+1)),0]]),"
        ;;
        BANDWIDTH)
            echo -n "        ('$OSDIR', ["
            num=`echo "$NA0" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$NA0" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0], [$(($num+1)),0]]),"
        ;;
        MEMORY)
            echo -n "        ('$OSDIR', ["
            num=`echo "$NA1" | wc -w`
            for((i=0; i<$num; i++))
            do
                j=$(($i+1))
                temp=`echo "$NA1" | awk '{print $'$j'}'`
                echo  -n "[$i, $temp], "   
            done
            echo -e "[$num, 0]]),"
        ;;
        esac
}
lmbench
