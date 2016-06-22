#!/bin/bash
HOMEINFO=`pwd`
COREINFO="$HOMEINFO/coreinfo"
HWINFO="$HOMEINFO/hwinfo"
kernel()
{
    if uname -a | awk '{print $3}' >/dev/null 2>&1
    then
        uname -a | awk '{print $3}'
    else
        echo "null"
    fi
}

os()
{
    if cat /etc/issue | head -n 1 | tr -d '\\' >/dev/null 2>&1
    then
        cat /etc/issue | head -n 1
    else
        echo "null"
    fi
}

fs()
{
    if df -T | awk '{if ($7 == "/") {print $2} else if($6 == "/") {print $1}}' >/dev/null 2>&1
    then
        df -T | awk '{if ($7 == "/") {print $2} else if($6 == "/") {print $1}}'
    else
        echo "null"
    fi
}

GCC()
{
    if gcc --version >/dev/null 2>&1
    then
        gcc --version 2>/dev/null | head -n 1
    else
        echo "null"
    fi
}

GJJ()
{
    if g++ --version >/dev/null 2>&1
    then
        g++ --version 2>/dev/null | head -n 1
    else
        echo "null"
    fi
}

GDB()
{
    if gdb --version >/dev/null 2>&1
    then
        gdb --version 2>/dev/null | head -n 1
    else
        echo "null"
    fi
} 

MAKE()
{
    if make --version >/dev/null 2>&1
    then
        make --version 2>&1 | awk -F, '{print $1}' | awk '/GNU Make/{print "Gnu make",$NF}'   
    else
        echo "null"
    fi
}

BINUTILS()
{
    if ld -v >/dev/null 2>&1
    then
        ld -v 2>&1 | awk -F\) '{print $1}' | awk '//{print "binutils    ",$(NF-1),$NF}'
    else
        echo "null"
    fi
}

UTIL()
{
    if fdformat --version >/dev/null 2>&1
    then
        fdformat --version 2>&1 | awk -F\- '{print "util-linux  ", $NF}'
    else
        echo "null"
    fi
}

MOUNT()
{
    if mount --version >/dev/null 2>&1
    then
        mount --version 2>&1 | awk -F\- '{print "mount ", $NF}'
    else
        echo "null"
    fi
}

MODUTILS()
{
    if insmod -V >/dev/null 2>&1
    then
        insmod -V  2>&1 | awk 'NR==1 {print "modutils  ",$NF}'
    else
        echo "null"
    fi
}

E2FSPROGS()
{
    if tune2fs 2>&1 | grep "^tune2fs" >/dev/null 2>&1
    then
        tune2fs 2>&1 | grep "^tune2fs" | sed 's/,//' |  awk 'NR==1 {print "e2fsprogs   ", $2}'
    else
        echo "null"
    fi
}

PPP()
{
    if pppd --version >/dev/null 2>&1
    then
        pppd --version 2>&1| grep version | awk 'NR==1{print "PPP ", $3}' 
    else
        echo "null"
    fi
}

GLBC()
{
    if ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed -e 's/\.so$//' | awk -F'[.-]'   '{print "Linux C Library   " $(NF-2)"."$(NF-1)"."$NF}' >/dev/null 2>&1
    then
        ls -l `ldd /bin/sh | awk '/libc/{print $3}'` | sed -e 's/\.so$//' | awk -F'[.-]'   '{print "Linux C Library   " $(NF-2)"."$(NF-1)"."$NF}'
    else
        echo "null"
    fi
}


LLVM()
{
    if rpm -qa >/dev/null 2>&1
    then
        rpm -qa | grep llvm | head -n 1
    else
        echo "null"
    fi
}

LDD()
{
    if ldd --version >/dev/null 2>&1
    then
        ldd --version |head -n 1 | awk 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
    else 
        echo "null"
    fi
}

CJJ()
{
    if ls -l /usr/lib/lib{g,stdc}++.so >/dev/null 2>&1
    then
        ls -l /usr/lib/lib{g,stdc}++.so  2>/dev/null | awk -F. '{print "Linux C++ Library " $4"."$5"."$6}'
    else
        echo "null"
    fi
}

PS()
{
    if ps --version >/dev/null 2>&1
    then
        ps --version 2>&1 | awk 'NR==1{print "Procps  ", $NF}'
    else
        echo "null"
    fi
}

IFCONFIG()
{
    if ifconfig --version >/dev/null 2>&1
    then
        ifconfig --version 2>&1 | grep tools | awk 'NR==1{print "Net-tools   ", $NF}'
    else
        echo "null"
    fi
}

IP()
{
    if ip -V >/dev/null 2>&1
    then 
        ip -V 2>&1 | awk 'NR==1{print "iproute2             ", $NF}'
    else
        echo "null"
    fi
}

KBD()
{
    if loadkeys -h 2>&1 | grep version >/dev/null 2>&1
    then
         loadkeys -h 2>&1 | awk '(NR==1 && ($3 !~ /option/)) {print "Kbd  ", $3}' 
    else
         echo "null"
    fi
}

SH()
{
    if expr --v >/dev/null 2>&1
    then
        expr --v 2>&1 | awk 'NR==1{print "Sh-utils    ", $NF}'
    else
        echo "null"
    fi
}
MODULES()
{
    if [ -e /proc/modules ]; then
        X=`cat /proc/modules | sed -e "s/ .*$//"`
        echo $X 
    else
        echo "null"
    fi
}

KDE()
{
    if rpm -qa | grep -w kdelibs-ktexteditor | awk -F- '{print $3}' >/dev/null 2>&1
    then
        rpm -qa | grep -w kdelibs-ktexteditor | awk -F- '{print $3}'
    else
        echo "null"
    fi
}

GNOME()
{
    if gnome-shell --version >/dev/null 2>&1
    then
        gnome-shell --version
    else
        echo "null"
    fi
}

XORG()
{
    cat /var/log/Xorg.0.log | grep -w "X.Org X Server"
}

MESA()
{
    if rpm -qa | grep mesa-libgbm | awk -F- '{print $3}' >/dev/null 2>&1
    then
        rpm -qa |grep mesa-libgbm | awk -F- '{print $3}'
    else
        echo "null"
    fi
}

JAVA()
{
    if java -version >/dev/null 2>&1
    then
        java -version 2>&1 | tr -d "\n"
    else
        echo "null"
    fi
}

CHORMIUM()
{
    if google-chrome -v >/dev/null 2>&1
    then 
        google-chrome -v 2>/dev/null
    else
        echo "null"
    fi
}

FIREFOX()
{
    if firefox -v >/dev/null 2>&1
    then
        firefox -v 2>/dev/null 
    else
        echo "null"
    fi
}

ROOT()
{
    if lsblk | grep -w / >/dev/null 2>&1
    then
        lsblk | grep -w / | tr -d "├─"
    else
        echo "null"
    fi
}

MEM()
{
    if free -m >/dev/null 2>&1
    then
        free -m | grep Mem | awk '{print $2}'
    else
        echo "null"
    fi
}

SWAP()
{
    if free -m >/dev/null 2>&1
    then
        free -m | grep Swap | awk '{print $2}'
    else
        echo "null"
    fi
}
coreinfo()
{
    OS=`os`
    KERNEL=`kernel`
    FS=`fs`
    GCC=`GCC`
    GJJ=`GJJ`
    GDB=`GDB`
    MAKE=`MAKE`
    BINUTILS=`BINUTILS`
    UTIL=`UTIL`
    MOUNT=`MOUNT`
    MODUTILS=`MODUTILS`
    E2FSPROGS=`E2FSPROGS`
    PPP=`PPP`
    GLIBC=`GLBC`
    LLVM=`LLVM`
    LDD=`LDD`
    CJJ=`CJJ`
    PS=`PS`
    IFCONFIG=`IFCONFIG`
    IP=`IP`
    KBD=`KBD`
    SH=`SH` 
    MODULES=`MODULES`        
    KDE=`KDE`
    GNOME=`GNOME`
    XORG=`XORG`
    MESA=`MESA`
    JAVA=`JAVA`
    CHORMIUM=`CHORMIUM`
    FIREFOX=`FIREFOX`
    ROOT=`ROOT`
    SWAP=`SWAP`
    MEM=`MEM`
    echo "**OS** | $OS" >> $COREINFO
    echo "**Kerne** | $KERNEL" >> $COREINFO
    echo "**File-System** | $FS" >> $COREINFO
    echo "**Gcc** | $GCC" >> $COREINFO
#    echo "**G++** | $GJJ" >> $COREINFO
#    echo "**Gdb** | $GDB" >> $COREINFO
#    echo "**Make** | $MAKE" >> $COREINFO
#    echo "**Binutils** | $BINUTILS" >> $COREINFO
#    echo "**Util-linux** | $UTIL" >> $COREINFO
#    echo "**Mount** | $MOUNT" >> $COREINFO
#    echo "**Modutils** | $MODUTILS" >> $COREINFO
#    echo "**E2fsprogs** | $E2FSPROGS" >> $COREINFO
#    echo "**PPP** | $PPP" >> $COREINFO
    echo "**CLibrary** | $GLIBC" >> $COREINFO
#    echo "**LLVM** | $LLVM" >> $COREINFO
#    echo "**Ldd** | $LDD" >> $COREINFO
 #   echo "**C++Library** | $CJJ" >> $COREINFO
 #   echo "**Procps** | $PS" >> $COREINFO
 #   echo "**Net-tools** | $IFCONFIG" >> $COREINFO
 #   echo "**Iproute2** | $IP" >>$COREINFO
 #   echo "**Kbd** | $KBD" >>$COREINFO
 #   echo "**Sh-utils** | $SH" >> $COREINFO
    echo "**Modules** | $MODULES" >> $COREINFO
#    echo "**Kde** | $KDE" >> $COREINFO
 #   echo "**Gnome** | $GNOME" >>$COREINFO
    echo "**Xorg** | $XORG" >> $COREINFO
 #   echo "**MESA** | $MESA" >> $COREINFO
 #   echo " **JAVA** | $JAVA" >> $COREINFO
#    echo "**Chrome** | $CHORMIUM" >>$COREINFO
#    echo "**Firefox** | $FIREFOX" >>$COREINFO
    echo "**Root** | $ROOT">> $COREINFO
    echo "**MEM** | $MEM" >>$COREINFO
    echo -e "**SWAP** | $SWAP \n" >> $COREINFO
}

if which  dmidecode >/dev/null 5>&1;then
    echo "dmidecode ok" >/dev/null
else
    dnf -y install dmidecode
fi
    
MBA()
{
    if ls /proc/boardinfo  >/dev/null 2>&1
    then
        echo `cat /proc/boardinfo | grep -i "board name" |awk '{print $4}'` 
    elif dmidecode -t system | grep -i System >/dev/null 2>&1; then
        MBVR=`dmidecode -t system | grep -i Manufacturer | awk '{print $2}'`
        MBIF=`dmidecode -t system | grep -i "Product Name" | awk '{$1 = ""; $2 = "" ; print }'`
        echo "$MBVR -$MBIF" 
    else
        echo "null" 
   fi
}

BIOSA()
{
    if ls /proc/boardinfo  >/dev/null 2>&1
    then
        echo `cat /proc/boardinfo | awk '$1=="Version" {print $3}'`
    elif dmidecode -t bios | grep Version >/dev/null 2>&1; then
        BIOSVR=`dmidecode -t bios | grep -i vendor | awk '{print $2}'`
        BIOSVE=`dmidecode -t bios | grep -i version | awk '{print $2}'`
        BIOSDT=`dmidecode -t bios | grep -i "release date:" | awk '{print $3}'`
        echo "$BIOSVR-$BIOSVE-$BIOSDT"
    else
        echo "null"
    fi
}

CPUA()
{
    if cat /proc/cpuinfo |grep -i 'model'|awk -F: '{print $2}'| sort |uniq | tr -d "\n" >/dev/null 2>&1
    then
        cat /proc/cpuinfo |grep -i 'model'|awk -F: '{print $2}'| sort |uniq | tr -d "\n"
    else
        echo "null"
    fi
}

MEMA()
{
    if dmidecode -t memory >/dev/null 2>&1
    then
        MEMNAME=`dmidecode -t memory | grep Manufacturer: | grep -v "\[Empty\]" | sort | uniq | awk '{print $2}'`
        MEMTYPE=`dmidecode -t memory | grep -w DDR[0-9] | uniq | awk '{print $2}'`
        MEMSPEED=`dmidecode -t memory | grep -w "Speed:" | grep -w MHz |sort|uniq | awk '{print $2,$3}'`
        MEMSIZE=`dmidecode -t memory  | grep Size: | grep MB | awk '{print $2 $3}' |uniq`
        MEMNUM=`dmidecode -t memory  | grep Size: | grep MB | wc -l`
        echo "$MEMNAME-$MEMTYPE-$MEMSPEED-$MEMSIZE x$MEMNUM"
    else
        echo "null"
    fi
}

NBA()
{
    if lspci |grep "00:00.0"|awk -F: '{print $3}' >/dev/null 2>&1
    then
        NB=`lspci |grep "00:00.0"|awk -F: '{print $3}'`
        DRIVER=`lspci -v | sed -n -e '/00:00.0/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
        echo "$NB:$DRIVER"
    else
        echo "null"
    fi
}

SBA()
{
    if lspci |grep "ISA bridge:"|awk -F: '{print $3}' >/dev/null 2>&1
    then
        SB=`lspci |grep "ISA bridge:"|awk -F: '{print $3}'`
        IRQ=`lspci |grep "ISA bridge:"|awk '{print $1}'`
        DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
        echo "$SB:$DRIVER"
    else
        echo "null"
    fi
}

VIDEOA()
{
    lspci |grep "VGA" >> /dev/null
    if [ "$?" -eq 0 ]
    then
        VGANO=`lspci |grep "VGA"|awk -F: '{print $3}' |wc -l`
        num=1
        while [ $num -le $VGANO ]
        do
            CARD=`lspci |grep "VGA"|awk -F: '{print $3}' | head -n $num | tail -n 1`
            IRQ=`lspci |grep "VGA"|awk '{print $1}' | head -n $num | tail -n 1`
            DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
            echo "{$CARD:$DRIVER}"
            num=$(($num + 1))
        done
    else 
        echo "null"
    fi
}

AUDIOA()
{
    lspci |grep "Audio" >> /dev/null
    if [ "$?" -eq 0 ]
    then   
        AUDNO=`lspci |grep "Audio"|awk -F: '{print $3}' |wc -l`
        num=1
        while [ $num -le $AUDNO ]
        do
            AUDCARD=`lspci |grep "Audio"|awk -F: '{print $3}' | head -n $num | tail -n 1`
            IRQ=`lspci |grep "Audio"|awk '{print $1}' | head -n $num | tail -n 1`
            DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
            echo "{$AUDCARD:$DRIVER}"
            num=$(($num + 1))
        done
    else
        echo "null"
    fi
}

WIRELESSA()
{
    lspci |grep "Wireless" >> /dev/null
    if [ $? -eq 0 ]
    then
         WLAN=`lspci | grep "Wireless" | awk -F: '{print $3}'`
         IRQ=`lspci | grep "Wireless" | awk '{print $1}'`
         WLANDRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
         echo "{$WLAN:$WLANDRIVER}"
    else
        echo "null"
    fi
}   

WIREDA()
{
    lspci |grep -E 'Network|Ethernet' >> /dev/null
    if [ "$?" -eq 0 ]
    then
        NETNO=`lspci |grep -E 'Network|Ethernet' |awk -F: '{print $3}' |wc -l`
        num=1
        while [ $num -le $NETNO ]
        do
            NET=`lspci |grep -E 'Network|Ethernet'|awk -F: '{print $3}' | head -n $num | tail -n 1`
            IRQ=`lspci |grep -E 'Network|Ethernet' | awk '{print $1}' | head -n $num | tail -n 1`
            DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
            echo "{$NET:$DRIVER}"
            num=$(($num + 1))
        done
    else
        echo "null"
    fi 
}

SATAA()
{
    lspci |grep SATA >> /dev/null
    if [ "$?" -eq 0 ]
    then
        SATANO=`lspci |grep SATA |awk -F: '{print $3}' |wc -l`
        num=1
        while [ $num -le $SATANO ]
        do
            SATA=`lspci |grep SATA | awk -F: '{print $3}' | head -n $num | tail -n 1`
            IRQ=`lspci |grep SATA | awk '{print $1}' | head -n $num | tail -n 1`
            DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
            echo "{$SATA:$DRIVER}"
            num=$(($num + 1))
        done
    else
        echo "null"
    fi
}

HDDA()
{
if cat /proc/scsi/scsi | grep ATA >/dev/null 2>&1;then
    HDDNUM=`cat /proc/scsi/scsi |grep ATA | wc -l`
    num=1
    while [ $num -le $HDDNUM ]
    do
        HDDTYPE=`cat /proc/scsi/scsi |grep ATA | awk -F: '{print $3}' | tr -d "Rev" | head -n $num | tail -n 1`
        echo "{$HDDTYPE}"
        num=$(($num + 1))
        done
elif cat /proc/scsi/scsi | grep "Vendor" >/dev/null 2>&1;then
    HDDNUM=`cat /proc/scsi/scsi | grep -E "Vendor" |  sed -n '/Vendor/,/Rev/p' |wc -l`
    num=1
    while [ $num -le $HDDNUM ]
    do
        HDDTYPE=`cat /proc/scsi/scsi | grep -E "Vendor" | grep -v 'DVD'| awk -F: '{print $3}' | tr -d "Rev" | head -n $num | tail -n 1` 
        num=$(($num + 1))
        echo "{$HDDTYPE}"
    done
else
    echo "null"
fi
}

ODDA()
{
    if cat /proc/scsi/scsi | grep -E "Vendor"  | grep -E "DVD|CD" | awk  '{print $2,$4,$5}' >/dev/null 2>&1
    then
        cat /proc/scsi/scsi | grep -E "Vendor"  | grep -E "DVD|CD" | awk  '{print $2,$4,$5}'
    else
        echo "null"
    fi
}

RAIDA()
{
    if lspci | grep RAID >/dev/null;then
        RAIDNO=`lspci | grep -i raid |wc -l`
        N=1
        while [ $N -le $RAIDNO ]
        do
            RAIDINFO=`lspci |grep -i 'RAID'|awk -F: '{print $3}' | head -n $N | tail -n 1`
            IRQ=`lspci |grep -i 'RAID'|awk '{print $1}' | head -n $N | tail -n 1`
            DRIVER=`lspci -v | sed -n -e '/'$IRQ'/,/Kernel/p' | grep "driver" | awk '{print $NF}'`
            echo "{$RAIDINFO:$DRIVER}"
            N=$(($N + 1))
        done
    else
        echo "null"
    fi
}    

BLUEA()
{
    dmesg | grep -i bluetooth >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
    echo `dmesg | grep -i bluetooth | grep -v initialized | awk -F: '{print $2}' | tr -d "\n"`
    else
        echo "null" 
    fi
}

KBA()
{
    cat /proc/bus/input/devices  | grep -i keyboard | grep Name >>/dev/null
    if [ $? -eq 0 ]
    then
        echo `cat /proc/bus/input/devices  | grep -v Virtual| grep -i keyboard | grep Name |uniq | awk -F= '{print $2}'`
    else
        echo "null"
    fi
}

MSA()
{
    cat /proc/bus/input/devices  | grep -i mouse | grep Name >>/dev/null
    if [ $? -eq 0 ]
        then
        echo `cat /proc/bus/input/devices  | grep -v Virtual| grep -i mouse | grep Name |uniq | awk -F= '{print $2}'`
    else
        echo "null"
    fi
}

USBA()
{
    ls /proc/scsi/usb-storage/ >>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        usbno=`ls /proc/scsi/usb-storage/ |wc -l`
        i=1
        while [ $i -le $usbno ]
        do
            scsino=`ls /proc/scsi/usb-storage | awk '{print $1}' |head -n $i| tail -n 1`
            usbVendor=`cat /proc/scsi/usb-storage/$scsino | awk '$1=="Vendor:" {print $2}'`
            if [ "$usbVendor" = "Unknown" ];then
                echo "null " 
            else
            usbProduct=`cat /proc/scsi/usb-storage/$scsino | grep "Product:"| awk -F: '{print $2}'`
            echo "{$usbVendor: $usbProduct}"
            fi
            i=$(($i + 1))
        done
    else
        echo "null"
    fi
}

hwinfo()
{
    MB=`MBA | tr -d "\n"`
    BIOS=`BIOSA | tr -d "\n"`
    CPU=`CPUA | tr -d "\n"`
    MEM=`MEMA | tr -d "\n"`
    NB=`NBA | tr -d "\n"`
    SB=`SBA | tr -d "\n"`
    VIDEO=`VIDEOA | tr -d "\n"`
    AUDIO=`AUDIOA | tr -d "\n"`
    WIRED=`WIREDA | tr -d "\n"`
    WIRELESS=`WIRELESSA | tr -d "\n"`
    SATA=`SATAA | tr -d "\n"`
    HDD=`HDDA | tr -d "\n"`
    ODD=`ODDA | tr -d "\n"`
    RAID=`RAIDA | tr -d "\n"`
    BLUE=`BLUEA | tr -d "\n"`
    KB=`KBA | tr -d "\n"`
    MS=`MSA | tr -d "\n"`
    USB=`USBA | tr -d "\n"`
    echo "**MB** | $MB" >> $HWINFO
    echo "**BIOS** | $BIOS" >> $HWINFO
    echo "**CPU** | $CPU" >> $HWINFO
    echo "**MEM** | $MEM" >> $HWINFO
    echo "**NB** | $NB" >> $HWINFO
    echo "**SB** | $SB" >> $HWINFO
    echo "**Video-Card** | $VIDEO" >> $HWINFO
    echo "**Audio-Card** | $AUDIO" >> $HWINFO
    echo "**Wired-LAN** | $WIRED" >> $HWINFO
    echo "**Wireless** | $WIRELESS" >> $HWINFO
    echo "**SATA-Cotroller** | $SATA" >> $HWINFO
    echo "**Hard-Disk** | $HDD" >> $HWINFO
    echo "**CD-ROM** | $ODD" >> $HWINFO
    echo "**RAID** | $RAID" >> $HWINFO
    echo "**Bluetooth** | $BLUE " >> $HWINFO
    echo "**Keyboard** | $KB" >> $HWINFO
    echo "**Mouse** | $MS" >> $HWINFO
    echo -e "**USB-Flash-Disk** | $USB \n" >> $HWINFO
}
hwinfo
coreinfo
