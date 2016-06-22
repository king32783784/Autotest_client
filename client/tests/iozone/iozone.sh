#! /bin/bash
IOZONERESULT="/mnt/results/default/iozone/results"
IORESULT="/home/Linux-version-test-result/Linux-test-result"
TESTS=8
TESTBITE=32
TESTSBITE=`echo "$TESTS * 1024 * 1024" | bc`
iozone()
{
    echo -e "\n" >>$IORESULT
    echo -e "## Iozone -Performance Test of File I/O \n" >>$IORESULT
    echo -e "Value -Kbytes/s- bigger is better\n" >>$IORESULT
    echo "*Item* | *KB* | *Reclen* | *Write* | *Rewrite* | *Read* | *Reread* | *Rondom read* | *Rondom write* " >>$IORESULT
    echo "------ | ---- | -------- | ------- | --------- | ------ | -------- | ------------- | -------------- " >>$IORESULT
    IO=`grep "8388608      32" $IOZONERESULT/raw_output_* |awk '{for(j=3;j<=NF;j++)printf $j" ";printf "\n"}' |awk '{for(n=0;n<=NF;n++)t[n]+=$n}END{for(n=1;n<=NF;n++)printf t[n]/NR"| ";print""}'`
    echo -e "**Average** |$TESTSBITE | $TESTBITE | $IO \n" >> $IORESULT
}
iozone
