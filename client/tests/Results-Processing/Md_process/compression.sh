#!/bin/bash
#by lp
OSDIR=$1
TYPE=$2
COMPESULT="Source_data/$OSDIR/default/pts.compression/results"

compression()
{
    zip=`sed -n -e '/compress-7zip/,/MIPS/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`

    pbzip=`sed -n -e '/compress-pbzip2/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    gzip=`sed -n -e '/compress-gzip/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    lzma=`sed -n -e '/compress-lzma/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    
    if [ $TYPE = "MORE" ]
    then
        echo "**$OSDIR** | $zip |"   
    else
        echo "**$OSDIR** | $pbzip | $gzip | $lzma |"
    fi
}
compression
    
    
     

