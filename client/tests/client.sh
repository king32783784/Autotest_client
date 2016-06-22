#! /bin/bash
#Check test suite for Linux startup scripts
#By lp

##Results Save
Resultdir=/home/Linux-version-test-result
mkdir $Resultdir
checkresult="$Resultdir/Linux-test-result"

##Pandoc css
cp tests/style.css $Resultdir

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
    dnf -y install x11perf 
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
echo -e "# L i n u x * Version * Check * Result \n" >> $checkresult

##Start the hardware, the core component inspection script
#sh tests/infotest/hwinfo.sh 
#sh tests/infotest/coreinfo.sh 

##Autotest start
echo 3 >/proc/sys/vm/drop_caches
./autotest-local control-client --output=/mnt

##Result saved and turn to html
cd $Resultdir
finalresult="systemtest-result-$(date +'%Y%m%d%H%M').html"
pandoc --toc -c ./style.css -o $Resultdir/$finalresult $checkresult
mv $Resultdir/Linux-test-result $checkresult-$(date +'%Y%m%d%H')
mv $Resultdir $Resultdir-$(date +'%Y%m%d')
firefox $finalresult
