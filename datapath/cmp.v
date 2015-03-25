`timescale 1ns/1ns

`include "cmpop_def.v"

module cmp (a,b,op,br);
   input [31:0]  a,b;
   input [2:0]   op;
   output        br;

   wire [31:0] result;
   wire        eq,zero,sign;

   assign eq=!result;
   assign zero=!a;
   assign result=a-b;
   assign sign=result[31];
   assign br=(op==`CMP_EQ)?eq:
             (op==`CMP_NE)?!eq:
             (op==`CMP_LEZ)?sign|zero:
             (op==`CMP_GTZ)?(!sign)&(!zero):
             (op==`CMP_LTZ)?sign:
             (op==`CMP_GEZ)?!sign:0;

endmodule
