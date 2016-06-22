#!/bin/sh

strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output1 2> /tmp/pingpong.out1
strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output2 2> /tmp/pingpong.out2
strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output3 2> /tmp/pingpong.out3
strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output4 2> /tmp/pingpong.out4
strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output5 2> /tmp/pingpong.out5
strace -tt -T ./pp32 -v -n 64 -i 100000 > /root/results/pingpong/64output6 2> /tmp/pingpong.out6
mkdir -p /root/results/pingpong/strace
cp /tmp/pingpong.out* /root/results/pingpong/strace/

#./pp32 -v -n 64 -i 100000 >>   /root/results/pingpong/64output
#./pp32 -v -n 64 -i 100000 >>   /root/results/pingpong/64output
#./pp32 -v -n 64 -i 100000 >>   /root/results/pingpong/64output
#./pp32 -v -n 64 -i 100000 >>   /root/results/pingpong/64output
#./pp32 -v -n 64 -i 100000 >>   /root/results/pingpong/64output

#./pp32 -v -n 256 -i 100000 >   /root/results/pingpong/256output
#./pp32 -v -n 256 -i 100000 >>   /root/results/pingpong/256output
#./pp32 -v -n 256 -i 100000 >>   /root/results/pingpong/256output
#./pp32 -v -n 256 -i 100000 >>   /root/results/pingpong/256output
#./pp32 -v -n 256 -i 100000 >>   /root/results/pingpong/256output
#./pp32 -v -n 256 -i 100000 >>   /root/results/pingpong/256output
