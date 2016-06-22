#!/bin/bash
ILERESULT="/home/Linux-version-test-result/Linux-test-result"
COMPESULT="/mnt/results/default/pts.encoding/results"

encoding()
{
    echo -e "## PTS - Performance Test of  Encoding \n" >> $ILERESULT
    echo -e "Encoding - More is better (Frames/second) \n" >> $ILERESULT
    echo "*Item* | *x264*" >> $ILERESULT
    echo "------ | ----- " >> $ILERESULT
    x264=`sed -n -e '/x264/,/Frames/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    echo -e "**Average** | $x264|\n" >>$ILERESULT

    echo -e "Encoding -Less is better (seconds) \n" >> $ILERESULT
    echo "*Item* | *encode-ape* | *encode-flac* | *encode-mp3* | *encode-ogg* | *encode-wavpack* | *ffmpeg* | *mencoder* " >> $ILERESULT  
    echo "------ | ------------ | ------------- | ------------ | ------------ | ---------------- | -------- | ---------- " >> $ILERESULT
    encodeape=`sed -n -e '/Monkey Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeflac=`sed -n -e '/FLAC Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodemp3=`sed -n -e '/LAME MP3 Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeogg=`sed -n -e '/Ogg Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodewavpack=`sed -n -e '/WavPack Audio Encoding/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    ffmpeg=`sed -n -e '/FFmpeg/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    mencoder=`sed -n -e '/Mencoder/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    echo -e "**Average** | $encodeape | $encodeflac | $encodemp3 | $encodeogg | $encodewavpack | $ffmpeg | $mencoder| \n" >>$ILERESULT
}
encoding
    
    
     

