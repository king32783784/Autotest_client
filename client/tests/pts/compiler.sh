#!/bin/bash
COMPESULT="/mnt/results/default/pts.compiler/results"
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
    
    
     

