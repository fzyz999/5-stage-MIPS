`timescale 1ns/1ns

module bridge (PrAddr,PrBe,PrWD,PrRD,HWInt,DevAddr,Dev1_WE,Dev1_RD,Dev1_Irq,Dev2_WE,Dev2_RD,Dev2_Irq,DevWd);
   input [31:2]  PrAddr;
   input [3:0]   PrBe;
   input [31:0]  PrWD;
   input [31:0]  Dev1_RD;
   input [31:0]  Dev2_RD;
   input         Dev1_Irq,Dev2_Irq;
   output [31:0] PrRD;
   output [7:2]  HWInt;
   output [3:2]  DevAddr;
   output [31:0] DevWd;
   output        Dev1_WE,Dev2_WE;

   wire          HitDev1,HitDev2;

   assign HitDev1=(PrAddr[31:4]==28'h0000_7f0);
   assign HitDev2=(PrAddr[31:4]==28'h0000_7f1);
   assign Dev1_WE=(HitDev1&&PrBe==4'b1111);
   assign Dev2_WE=(HitDev2&&PrBe==4'b1111);
   assign DevWd=PrWD;
   assign PrRD=(HitDev1)?Dev1_RD:
               (HitDev2)?Dev2_RD:
               32'haabb_ccdd;
   assign DevAddr=PrAddr[3:2];
   assign HWInt={4'b0000,Dev2_Irq,Dev1_Irq};

endmodule // bridge
