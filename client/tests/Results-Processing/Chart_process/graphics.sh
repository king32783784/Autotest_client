#!/bin/bash
#by lp

OSDIR=$1
TYPE=$2
COMPESULT="Source_data/$OSDIR/default/pts.graphics/results"

graphics()
{
    gtkperf=`sed -n -e '/GtkPerf/,/Average/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`

    qgears=`sed -n -e '/QGears2/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    doom=`sed -n -e '/Doom/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    etqw=`sed -n -e '/ET:/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    lightsmark=`sed -n -e '/Lightsmark/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    nexuiz=`sed -n -e '/Nexuiz/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    prey=`sed -n -e '/Prey/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    unigine=`sed -n -e '/Unigine Sanctuary/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    tropics=`sed -n -e '/Unigine Tropics/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`
    vdrift=`sed -n -e '/VDrift/,/Frames/p' $COMPESULT/raw_output_desktop-graphics | grep Average | awk '{print $2}'`

    if [ $TYPE = "LESS" ]
    then
        echo "('$OSDIR', [[0,$gtkperf], [1,0]]),"   
    else
        echo "('$OSDIR', [[0,$qgears], [1,$doom], [2,$etqw], [3,$lightsmark], [4,$nexuiz], [5,$prey], [6,$unigine], [7,$tropics], [8,$vdrift], [9,0]]),"
    fi  
}
graphics
    
    
     

