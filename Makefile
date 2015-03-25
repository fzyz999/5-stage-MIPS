datapathDir=./datapath
controlDir=./control

test:mips.v test.v bridge.v timer.v code.txt
	dp=`ls ${datapathDir}/*.v`;ctl=`ls ${controlDir}/*.v`;iverilog -I ${controlDir} -I ${datapathDir} -o test test.v mips.v bridge.v timer.v $$dp $$ctl -Wall
	vvp -n test -lxt2
