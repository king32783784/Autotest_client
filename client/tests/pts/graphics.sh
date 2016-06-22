#!/bin/bash
ILERESULT="/home/Linux-version-test-result/Linux-test-result"
COMPESULT="/mnt/results/default/pts.graphics/results"
graphics()
{
    echo -e "## PTS - Performance Test of Graphics \n" >> $ILERESULT
    echo -e "Graphics - Less is better (Frames/second) \n" >> $ILERESULT
    echo "*Item* | *gtkperf*" >> $ILERESULT
    echo "------ | ----- " >> $ILERESULT
    gtkperf=`sed -n -e '/QGears2/,/Average/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    echo -e "**Average** | $gtkperf| \n" >>$ILERESULT

    echo -e "Graphics -More is better (seconds) \n" >> $ILERESULT
    echo "*Item* | *qgears2* | *doom3* | *etqw* | *lightsmark* | *nexuiz* | *prey* | *unigine-sanctuary* | *unigine-tropics* | *vdrift*" >> $ILERESULT  
    echo "------ | --------- | ------- | ------ | ------------ | -------- | ------ | ------------------- | ----------------- | --------" >> $ILERESULT
    qgears=`sed -n -e '/QGears2/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    doom=`sed -n -e '/Doom/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    etqw=`sed -n -e '/ET:/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    lightsmark=`sed -n -e '/Lightsmark/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    nexuiz=`sed -n -e '/Nexuiz/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    prey=`sed -n -e '/Prey/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    unigine=`sed -n -e '/Unigine Sanctuary/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    tropics=`sed -n -e '/Unigine Tropics/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    vdrift=`sed -n -e '/VDrift/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    echo -e "**Average** | $qgears | $doom | $etqw | $lightsmark | $nexuiz | $prey | $unigine | $tropics | $vdrift |\n" >>$ILERESULT
}
graphics
    
    
     

