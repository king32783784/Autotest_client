#! /bin/bash
HWINFORESULT="/mnt/results/default/infotest/results/hwinfo"
COREINFORESULT="/mnt/results/default/infotest/results/coreinfo"
SYSRESULT="/home/Linux-version-test-result/Linux-test-result"
echo -e "## Hardware Info of Identifying by System\n" >> $SYSRESULT
echo "*Item* | *Details*" >> $SYSRESULT
echo "------- | --------" >> $SYSRESULT
cat $HWINFORESULT >>$SYSRESULT
echo -e "\n" >> $SYSRESULT
echo -e "## Core Components and System Configuration Information" >> $SYSRESULT
echo "*Item* | *Details*" >> $SYSRESULT
echo "------- | --------" >> $SYSRESULT
cat $COREINFORESULT >> $SYSRESULT
echo -e "\n" >>$SYSRESULT
