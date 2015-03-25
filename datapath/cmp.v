`timescale 1ns/1ns

module cmp (i1,i2,zero,sign);
   input [31:0]  i1,i2;
   output        zero;
   output        sign;

   wire [31:0] result;

   assign zero=!result;
   assign result=i1-i2;
   assign sign=result[31];

endmodule
