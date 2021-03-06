#!/bin/bash
#by lp

OSDIR=$1
TYPE=$2
COMPESULT="Source_data/$OSDIR/default/pts.encoding/results"

encoding()
{
    x264=`sed -n -e '/x264/,/Frames/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`

    encodeape=`sed -n -e '/Monkey Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeflac=`sed -n -e '/FLAC Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodemp3=`sed -n -e '/LAME MP3 Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeogg=`sed -n -e '/Ogg Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodewavpack=`sed -n -e '/WavPack Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    ffmpeg=`sed -n -e '/FFmpeg/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    mencoder=`sed -n -e '/Mencoder/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    
    if [ $TYPE = "MORE" ]
    then
        echo "**$OSDIR** | $x264 |"   
    else
        echo "**$OSDIR** | $encodeape | $encodeflac | $encodemp3 | $encodeogg | $encodewavpack | $ffmpeg | $mencoder |"
    fi
}
encoding
    
    
     

