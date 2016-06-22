#!/bin/bash
COMPESULT="/mnt/results/default/pts/results"
ILERESULT="/home/Linux-version-test-result/Linux-test-result"

compiler()
{
    echo -e "## PTS - Performance Test of Comiler  Test  \n" >> $ILERESULT
    echo -e "Compiler - More is better \n" >> $ILERESULT
    echo "*Item* | *npb (Mop/s)* | *Ripper-Blowfish (Real C/S)* | *x264 (Frames/s)* | *GraphicsMgick-sharpen (Iterations)* | *GraphicsMgick-Resizing (Iterations)* | *GraphicsMgick-HWColor (Iz    terations)* | *7-zip (MIPS)* | *OpenSSL (Signs/s)* | *Apache (Requests/s)*" >> $ILERESULT
    echo "---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ----" >> $ILERESULT
    npb=`sed -n -e '/npb-1.2.1/,/Mop\/s/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Ripper=`sed -n -e '/Ripper/,/C\/S/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    x264=`sed -n -e '/Test 5 of 21/,/Frames/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Sharpen=`sed -n -e '/Sharpen/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`   
    Resizing=`sed -n -e '/Resizing/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    HWBColor=`sed -n -e '/HWB Color Space/,/Iterations/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Zip=`sed -n -e '/7-Zip/,/MIPS/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    openssl=`sed -n -e '/OpenSSL/,/Signs/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    apache=`sed -n -e '/Apache Benchmark/,/Requests/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    echo -e "**Average** | $npb | $Ripper | $x264 | $Sharpen | $Resizing | $HWBColor | $Zip | $openssl | $apache |\n" >>$ILERESULT

    echo -e "Compiler -Timed less is better \n" >> $ILERESULT
    echo "*Item* | *hmmer (Seconds)* | *gcrypt (Microseconds)* | *TimedApache (senconds)* | *TimedImageMagick (seconds)* | *Timedphp (seconds)* | *C-ray (seconds)* | *Bullet-Raytests (seconds    )* | *Bullet-3000Fall (seconds)* | *Bullet-1000Stack (seconds)* | *Bullet-1000Convex (seconds)* | *Bullet-Convex-Trimesh (seconds)* | *LAME-MP3 (seconds)* " >> $ILERESULT  
    echo "----| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ----" >> $ILERESULT
    hmmer=`sed -n -e '/Timed HMMer Search/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    gcrypt=`sed -n -e '/Gcrypt/,/Microseconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    TimedApache=`sed -n -e '/Timed Apache/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'` 
    TimedImageMagick=`sed -n -e '/Timed ImageMagick/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    TimedPHP=`sed -n -e '/Timed PHP/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    CRay=`sed -n -e '/C-Ray/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Raytests=`sed -n -e '/Raytests/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Fall=`sed -n -e '/3000 Fall/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Stack=`sed -n -e '/1000 Stack/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Convex=`sed -n -e '/1000 Convex/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    Trimesh=`sed -n -e '/Convex Trimesh/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    encodemp3=`sed -n -e '/LAME MP3/,/Seconds/p' $COMPESULT/raw_output_compiler | grep Average | awk '{print $2}'`
    echo -e "**Average** | $hmmer | $gcrypt | $TimedApache | $TimedImageMagick | $TimedPHP | $CRay | $Raytests | $Fall | $Stack | $Convex | $Trimesh | $encodemp3|\n" >>$ILERESULT
}
compiler

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
    encodeape=`sed -n -e '/encode-ape/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeflac=`sed -n -e '/encode-flac/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodemp3=`sed -n -e '/encode-mp3/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodeogg=`sed -n -e '/encode-ogg/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    encodewavpack=`sed -n -e '/encode-wavpack/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    ffmpeg=`sed -n -e '/ffmpeg/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    mencoder=`sed -n -e '/mencoder/,/Seconds/p' $COMPESULT/raw_output_encoding | grep Average | awk '{print $2}'`
    echo -e "**Average** | $encodeape | $encodeflac | $encodemp3 | $encodeogg | $encodewavpack | $ffmpeg | $mencoder| \n" >>$ILERESULT
}
encoding
    

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
    
    
graphics()
{
    echo -e "## PTS - Performance Test of Graphics \n" >> $ILERESULT
    echo -e "Graphics - More is better (Frames/second) \n" >> $ILERESULT
    echo "*Item* | *gtkperf*" >> $ILERESULT
    echo "------ | ----- " >> $ILERESULT
    gtkperf=`sed -n -e '/QGears2/,/Average/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    echo -e "**Average** | $gtkperf| \n" >>$ILERESULT

    echo -e "Graphics -Less is better (seconds) \n" >> $ILERESULT
    echo "*Item* | *qgears2* | *doom3* | *etqw* | *lightsmark* | *nexuiz* | *prey* | *unigine-sanctuary* | *unigine-tropics* | *vdrift*" >> $ILERESULT  
    echo "------ | --------- | ------- | ------ | ------------ | -------- | ------ | ------------------- | ----------------- | --------" >> $ILERESULT
    qgears=`sed -n -e '/qgears2/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    doom=`sed -n -e '/Doom/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    etqw=`sed -n -e '/ET:/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    lightsmark=`sed -n -e '/Lightsmark/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    nexuiz=`sed -n -e '/Nexuiz/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    prey=`sed -n -e '/Prey/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    unigine=`sed -n -e '/Unigine-sanctuary/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    tropics=`sed -n -e '/Unigine-tropics/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    vdrift=`sed -n -e '/Vdrift/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    echo -e "**Average** | $qgears | $doom | $etqw | $lightsmark | $nexuiz | $prey | $unigine | $tropics | $vdrift |\n" >>$ILERESULT
}
graphics
    
    
     

