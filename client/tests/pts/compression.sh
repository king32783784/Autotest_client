#!/bin/bash
ILERESULT="/home/Linux-version-test-result/Linux-test-result"
COMPESULT="/mnt/results/default/pts.compression/results"

compression()
{
    echo -e "## PTS - Performance Test of Compression  \n" >> $ILERESULT
    echo -e "Compression - More is better(mips) \n" >> $ILERESULT
    echo "*Item* | *7-Zip* " >> $ILERESULT
    echo "------ | ----- " >> $ILERESULT
    zip=`sed -n -e '/compress-7zip/,/MIPS/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    echo -e "**Average** | $zip| \n" >>$ILERESULT

    echo -e "Compression -Less is better (seconds) \n" >> $ILERESULT
    echo "*Item* | *compress-pbzip2* | *compress-gzip* | *compress-lzma*" >> $ILERESULT  
    echo "------ | ----------------- | --------------- | ---------------" >> $ILERESULT
    pbzip=`sed -n -e '/compress-pbzip2/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    gzip=`sed -n -e '/compress-gzip/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    lzma=`sed -n -e '/compress-lzma/,/Seconds/p' $COMPESULT/raw_output_compression | grep Average | awk '{print $2}'`
    echo -e "**Average** | $pbzip | $gzip | $lzma| \n" >>$ILERESULT
}
compression
    
    
     

