#! /bin/bash
#Check test suite for Linux startup scripts
#By lp

##Results Save
HOMEDIR=`pwd`
OSNAME=`cat /etc/issue | head -n 1 | sed -e 's/ /-/g'`
Resultdir=$HOMEDIR/Result-tmp
SOURCERESULT="$HOMEDIR/Results-Processing/Source_data/$OSNAME/default/"
LTPSTRESS="ltpstress (Kernel Stability Test)"
LTPBASIC="ltprunall (System Basic Check Test)"
IO="iozone (File System Performance test)"
INFO="infotest (Hardware info & Core info)"
NT="netperf2 (Network Performance Test)"
SYSCPU="sysbench.cpu (CPU Performance Test)"
SYSMEM="sysbench_mem (MEM Performance Test)"
PP="pingpong (Threads Manager Performance Test)"
UNIX="unixbench5 (Os Performance Test)"
LM="lmbench (Kernel Performance Test)"
COMPILER="pts.compiler (Compiler Performance Test)"
ENCOD="pts.encoding (Encoding Performance Test)"
COMP="pts.compress (Compress Performance Test)"
GFC="pts.graphics (Graphics Performance Test)"
ALL="All Test Case"

if which zenity >/dev/null 2>&1;then
    echo "zenity ok"
else
    dnf -y  install zenity
fi

SELECTION=`zenity --list --checklist --multiple --title="版本检查测试套件-桌面版"  --text="选择您想进行的测试项目"  --width=1000 --height=1000 --column "" --column "支持测试项目" True "$INFO"  Fasle "$SYSCPU"   Fasle "$SYSMEM" Fasle "$PP" Fasle "$NT" Fasle "$IO" Fasle "$UNIX" Fasle "$LM" Fasle "$COMPILER"  Fasle "$ENCOD" Fasle "$COMP" Fasle "$GFC" Fasle "$LTPSTRESS" Fasle "$LTPBASIC" Fasle "$ALL"`
setup()
{

    rm -rf $Resultdir
    mkdir $Resultdir
    rm -rf $SOURCERESULT
    mkdir -p $SOURCERESULT
##Check tool is installed
#gcc
    if which gcc >/dev/null 2>&1 ; then
        echo "gcc ok" >/dev/null
    else
        dnf -y instll gcc
    fi
#unixbench
    if ls /usr/include/X11/Xlib.h >/dev/null 2>&1;then
       echo "X11 ok" 
    else
       dnf install xorg-x11*
    fi
    if which x11perf >/dev/null 2>&1; then
        echo "X11per ok" >/dev/null
    else
        cd x11perf-1.4.1
        make clean
        ./configure
        make && make install
        cd ..
    fi
#ltpstress
    if which sar >/dev/null 2>&1;then
        echo "sar OK" >/dev/null
    else
        dnf -y install sysstat
    fi
#autotest
    if which patch >/dev/null 2>&1;then
        echo "patch ok" >/dev/null
    else
        dnf -y install patch
    fi
#pandoc
    if which pandoc >/dev/null 2>&1;then
        echo "pandoc ok "
    else
        dnf -y install pandoc
    fi
#sysbench
    if which aclocal >/dev/null 2>&1;then
        echo "aclocal ok"
    else
        dnf -y install automake
    fi
    if which libtool >/dev/null 2>&1;then
        echo "libtool ok "
    else
        dnf -y install libtool
    fi
#PTS
    if which php >/dev/null 2>&1;then
        echo "Php ok "
    else
        dnf -y install php php-xml
    fi
    if which wget >/dev/null 2>&1;then
        echo "wget ok"
    else
        dnf -y install wget
    fi
    pip install pexpect
##Clean up existing installation package
    [ -x tmp/iozone ] && rm -rf tmp/iozone
    [ -x tmp/lmbench ] && rm -rf tmp/lmbench
    [ -x tmp/ltp ] && rm -rf tmp/ltp
    [ -x tmp/ltp_stress ] && rm -rf tmp/ltp_stress
    [ -x tmp/netperf2 ] && rm -rf tmp/netperf2
    [ -x tmp/sysbench ] && rm -rf tmp/sysbench
    [ -x tmp/unixbench5 ] && rm -rf tmp/unixbench5
    [ -x tmp/pts ] && rm -rf tmp/pts
    [ -x tmp/pingpong ] && rm -rf tmp/pingpong
    [ -x tmp/infotest ] && rm -rf tmp/infotest
## Importing the resulting document title
##    echo -e "# L i n u x * Version * Check * Result \n" >> $checkresult

##Start the hardware, the core component inspection script
#sh tests/infotest/hwinfo.sh 
#sh tests/infotest/coreinfo.sh 

##Autotest start
    echo 3 >/proc/sys/vm/drop_caches
}
if [ -e "$SELECTION" ] 
then
    exit
fi
checkip()
{
    if [ $# -lt 1 ];then
 #   zenity --warning --icon-name="IP输入异常" --text="Netserverip 不能为空！" --width=50 --height=100
        if zenity --question --text="您确定跳过输入IP吗？不指定NetserverIP,Netperf将不能正常运行" --width=600 ==height=400
        then
            return 0
        else
            return 1
        fi
    fi
    if echo $1 | egrep -q '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
        a=`echo $1 | awk -F. '{print $1}'`
        b=`echo $1 | awk -F. '{print $1}'`
        c=`echo $1 | awk -F. '{print $1}'`
        d=`echo $1 | awk -F. '{print $1}'`
        for n in $a $b $c $d;do
            if [ $n -ge 255 ] || [ $n -le 0 ];then
               # echo 'bad ip(2)!'
               zenity --warning --icon-name="格式错误" --text="IP地址类型不匹配!请重新输入" --width=300 --height=200
               sleep 1
                return 2
            fi
        done
    else
        #echo 'bad ip(1)!'
        zenity --warning --icon-name="格式错误" --text="IP地址只能为数字!请重新输入" --width=300 --height=200
        sleep 1    
        return 1
    fi
}
if echo $SELECTION | grep Netperf >/dev/null 2>&1;then
    Serverip=`zenity --entry --text="请输入Netserver ip,输入前请确认Server端已设置完毕！"`
    checkip $Serverip
    returnno=`echo $?`
    while :
    do
        if [ $returnno -gt 0 ];then
           Serverip=`zenity --entry --text="请输入Netserver ip,输入前请确认Server端已设置完毕！"`
           checkip $Serverip
           returnno=`echo $?`
        else
            break
        fi
    done
    
    sed -i "s/server_ip='*.*.*.*',/server_ip='$Serverip',/g" client-test-control/netperf-control
fi
setup
SECTNUM=`echo $SELECTION | awk -F "|" '{print NF}'`
for (( i=1; i<=$SECTNUM; i++))
do
    TESTITEM=`echo $SELECTION | awk -F "|" '{print $'$i'}' | awk '{print $1}'`
    ITEM="$ITEM $TESTITEM"
done
for (( i=1; i<=$SECTNUM; i++))
do
    TESTITEM=`echo $SELECTION | awk -F "|" '{print $'$i'}' | awk '{print $1}'`
    case $TESTITEM in
        ltpstress)
            ./autotest-local client-test-control/ltpstress-control --out=$Resultdir/ltpstress
            ;;
        ltprunall)
            ./autotest-local client-test-control/ltprunall-control --out=$Resultdir/ltprunall
            ;;
        iozone)
            ./autotest-local client-test-control/iozone-control --out=$Resultdir/iozone
            ;;
        infotest)
            ./autotest-local client-test-control/Systeminfo-control --out=$Resultdir
            mv $Resultdir/results/default/infotest $SOURCERESULT
            ;;
        netperf2)
            ./autotest-local client-test-control/netperf-control --out=$Resultdir/netperf2
            ;;
        sysbench.cpu)
            ./autotest-local client-test-control/sysbench_CPU-control --out=$Resultdir
            mv $Resultdir/results/default/sysbench.cpu $SOURCERESULT
            ;;
        sysbench.mem)
            ./autotest-local client-test-control/sysbench_MEM-control --out=$Resultdir/sysbench.mem
            ;;
        pingpong)
            ./autotest-local client-test-control/pingpong-control --out=$Resultdir/pingpong
            ;;
        unixbench5)
            ./autotest-local client-test-control/unixbench-control --out=$Resultdir/unixbench5
            ;;
        lmbench)
            ./autotest-local client-test-control/lmbench-control --out=$Resultdir/lmbench
            ;;
        pts.compiler)
            ./autotest-local client-test-control/pts_compiler-control --out=$Resultdir/pts.compiler
            ;;
        pts.compress)
            ./autotest-local client-test-control/pts_compress-control --out=$Resultdir/pts.compress
            ;;
        pts.encoding)
            ./autotest-local client-test-control/pts_encoding-control --out=$Resultdir/pts.encoding
            ;;
        pts.graphics)
            ./autotest-local client-test-control/pts_graphics-control --out=$Resultdir/pts.graphics
            ;;
        ALL)
            ./autotest-local client-test-control/client-control --out=$Resultdir/ALL
            ;;
        esac
done
cd $HOMEDIR/Results-Processing/
echo $ITEM
./mkresult -d "$HOMEDIR" -i "$ITEM" -s "$OSNAME"
firefox ../Linux-version-test-result-*/*.html
