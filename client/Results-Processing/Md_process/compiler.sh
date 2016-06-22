#!/bin/bash
#by lp
OSDIR=$1
TYPE=$2
COMPESULT="Source_data/$OSDIR/default/pts.compiler/results"

check()
{
    if [ $1 > 0 ]
    then
        echo $1
    else
        echo 0
   fi
}

compiler()
{
    Npb=`sed -n -e '/npb-1.2.1/,/Mop\/s/p' $COMPESULT/raw_output_compiler | grep Average | awk '{ print $2}'`
    Ripper=`sed -n -e '/Ripper/,/C\/S/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    X264=`sed -n -e '/Test 5 of 21/,/Frames/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Sharpen=`sed -n -e '/Sharpen/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`   
    Resizing=`sed -n -e '/Resizing/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Hwbcolor=`sed -n -e '/HWB Color Space/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Zip=`sed -n -e '/7-Zip/,/MIPS/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Openssl=`sed -n -e '/OpenSSL/,/Signs/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Apache=`sed -n -e '/Apache Benchmark/,/Requests/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Hmmer=`sed -n -e '/Timed HMMer Search/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Gcrypt=`sed -n -e '/Gcrypt/,/Microseconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    TimedApache=`sed -n -e '/Timed Apache/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'` 
    TimedImageMagick=`sed -n -e '/Timed ImageMagick/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{$2=$2+0 } END{ printf $2}'`
    TimedPHP=`sed -n -e '/Timed PHP/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Cray=`sed -n -e '/C-Ray/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Raytests=`sed -n -e '/Raytests/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Fall=`sed -n -e '/3000 Fall/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Stack=`sed -n -e '/1000 Stack/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Convex=`sed -n -e '/1000 Convex/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Trimesh=`sed -n -e '/Convex Trimesh/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Encodemp3=`sed -n -e '/LAME MP3/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    X264=`check $X264`
    Npb=`check $Npb`
    Ripper=`check $Ripper`
    Sharpen=`check $Sharpen`
    Resizing=`check $Resizing`
    Hwbcolor=`check $Hwbcolor`
    Zip=`check $Zip`
    Openssh=`check $Openssh`
    Apache=`check $Apache`
    Hmmer=`check $Hmmer`
    Gcrypt=`check $Gcrypt`
    TimedApache=`check $TimedApache`
    TimedImageMagick=`check $TimedImageMagick`
    TimePHP=`check $TimePHP`
    Cray=`check $Cray`
    Raytests=`check $Raytests`
    Fall=`check $Fall`
    Stack=`check $Stack`
    Convex=`check $Convex`
    Trimesh=`check $Trimesh`
    Encodemp3=`check $Encodemp3`
    if [ $TYPE = "MORE" ]
    then
        echo "**$OSDIR** | $Npb | $Ripper | $X264 | $Sharpen | $Resizing | $Hwbcolor | $Zip | $Openssl | $Apache |"   
    else
        echo "**$OSDIR** | $Hmmer | $Gcrypt | $TimedApache | $TimedImageMagick | $TimedPHP | $Cray | $Raytests | $Fall | $Stack | $Convex | $Trimesh | $Encodemp3 |"
    fi
}
compiler
    
    
     

