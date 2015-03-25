test=test_dm_4k test_ext test_gpr test_alu test_pc
datapathDir=../datapath

all:$(test)
.PHONY:all

test_dm_4k:test_dm_4k.v $(datapathDir)/dm.v
	iverilog -o test_dm_4k test_dm_4k.v $(datapathDir)/dm.v
	vvp -n test_dm_4k -lxt2

test_ext:test_ext.v ${datapathDir}/ext.v
	iverilog -o test_ext test_ext.v $(datapathDir)/ext.v
	vvp -n test_ext -lxt2

test_gpr:test_gpr.v $(datapathDir)/gpr.v
	iverilog -o test_gpr test_gpr.v $(datapathDir)/gpr.v
	vvp -n test_gpr -lxt2

test_alu:test_alu.v $(datapathDir)/alu.v
	iverilog -o test_alu test_alu.v $(datapathDir)/alu.v
	vvp -n test_alu -lxt2

test_pc:test_pc.v $(datapathDir)/pc.v
	iverilog -o test_pc test_pc.v $(datapathDir)/pc.v
	vvp -n test_pc -lxt2