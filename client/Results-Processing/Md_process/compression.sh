#!/bin/bash
#by lp
OSDIR=$1
TYPE=$2
COMPESULT="Source_data/$OSDIR/default/pts.compression/results"

check()
{
    if [ $1 > 0 ]
    then
        echo $1
    else
        echo 0
   fi
}

compression()
{
    zip=`sed -n -e '/compress-7zip/,/MIPS/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`

    pbzip=`sed -n -e '/compress-pbzip2/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    gzip=`sed -n -e '/compress-gzip/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    lzma=`sed -n -e '/compress-lzma/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    
    zip=`check $zip`
    pbzip=`check $pbzip`
    gzip=`check $gzip`
    lzma=`check $lzma`
    if [ $TYPE = "MORE" ]
    then
        echo "**$OSDIR** | $zip |"   
    else
        echo "**$OSDIR** | $pbzip | $gzip | $lzma |"
    fi
}
compression
    
    
     

