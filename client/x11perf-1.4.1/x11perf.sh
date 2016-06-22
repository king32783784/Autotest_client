#!/bin/bash
#by lp

setup()
{
    ./configure
    make
    make install
}

main()
{
    [ -e x11perf.log ] && rm -f x11perf.log
    dat=$(date +%s -d "$1 hour")
    while :
    do
        date >> x11perf.log
        tim=$(date +%s)
        if [ $tim -lt $dat ];then
        sleep 10
        ./x11perf -a | tee -a x11perf.log
        else
        break
        fi
    done
    date >> x11perf.log
}
main $1
