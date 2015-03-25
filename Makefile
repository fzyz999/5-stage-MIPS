datapathDir=./datapath
controlDir=./control

test:mips.v test.v code.txt
	dp=`ls ${datapathDir}/*.v`;ctl=`ls ${controlDir}/*.v`;iverilog -o test test.v mips.v $$dp $$ctl
	vvp -n test -lxt2
