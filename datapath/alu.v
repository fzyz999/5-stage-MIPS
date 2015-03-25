`timescale 1ns/1ns

module alu (i1,i2,op,sa,result,zero,sign);
   input [31:0]  i1,i2;
   input [2:0]   op;
   input [10:6]  sa;
   output [31:0] result;
   output        zero;
   output        sign;

   assign zero=!result;
   assign result=(op==3'b000)?i1+i2:
                 (op==3'b001)?i1-i2:
                 (op==3'b111)?i1 ^ i2:
                 (op==3'b011)?i1<<sa:
					  (op==3'b100)?i1 & i2:
					  i1|i2;
   assign sign=result[31];

endmodule
