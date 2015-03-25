`timescale 1ns/1ns

module alu (i1,i2,op,sa,result,zero,sign);
   input [31:0]  i1,i2;
   input [1:0]   op;
   input [10:6]  sa;
   output [31:0] result;
   output        zero;
   output        sign;

   assign zero=!result;
   assign result=(op==2'b00)?i1+i2:
                 (op==2'b01)?i1-i2:
                 (op==2'b10)?i1|i2:
                 i1<<sa;
   assign sign=result[31];

endmodule
