`timescale 1ns/1ns

module test_mips (/*port details*/);
   reg         clk,rst,clk_i;
   integer     i;

   wire [31:2] PrAddr;
   wire [3:0]  PrBe;
   wire [31:0] PrWD;
   wire [31:0] PrRD;
   wire [7:2]  HWInt;

   wire [31:0] Dev1_RD;
   wire [31:0] Dev2_RD;
   wire        Dev1_Irq,Dev2_Irq;
   wire [3:2]  DevAddr;
   wire [31:0] DevWd;
   wire        Dev1_WE,Dev2_WE;

   mips _mips(clk,rst,PrAddr,PrBe,PrRD,PrWD,HWInt);
   bridge _bridge(PrAddr,PrBe,PrWD,PrRD,HWInt,DevAddr,Dev1_WE,Dev1_RD,Dev1_Irq,Dev2_WE,Dev2_RD,Dev2_Irq,DevWd);
   coco_timer _coco_timer1(clk_i,rst,DevAddr,Dev1_WE,DevWd,Dev1_RD,Dev1_Irq);
   coco_timer _coco_timer2(clk_i,rst,DevAddr,Dev2_WE,DevWd,Dev2_RD,Dev2_Irq);

   always #5 clk=~clk;
   always #5 clk_i=~clk_i;

   initial begin
      clk=1;
      clk_i=1;
      rst=1;
      #3 rst=0;
   end

   initial begin
      #10000 $finish;
   end

   initial begin
      /*$monitor("%t IF(%x) ID(%x) EX(%x) MEM(%x) WB(%x)",$time,
       _mips.instr,_mips.instrD,_mips.instrE,_mips.instrM,_mips.instrW);*/
      #9999
        for (i=0; i!=2048; i=i+8) begin
           $display("%x %x %x %x %x %x %x %x",
                    _mips._dm._dm[i],
                    _mips._dm._dm[i+1],
                    _mips._dm._dm[i+2],
                    _mips._dm._dm[i+3],
                    _mips._dm._dm[i+4],
                    _mips._dm._dm[i+5],
                    _mips._dm._dm[i+6],
                    _mips._dm._dm[i+7]);
        end
   end


   initial begin
      $dumpfile("test.lxt");
      $dumpvars(0,test_mips);
   end

endmodule // test_mips
