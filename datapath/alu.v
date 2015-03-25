`timescale 1ns/1ns

`include "aluop_def.v"

module ShiftRight(
                  input signed [31:0] inp,
                  input [4:0]         shamt,
                  input               isSrl,
                  output [31:0]       out
                  );

   assign out = (isSrl)? $signed(inp>>shamt):
                (inp>>>shamt);

endmodule

module alu (a,b,op,c,over);
   input [31:0]  a,b;
   input [3:0]   op;
   output [31:0] c;
   output        over;

   wire [31:0]   tmp,slt_result;
   wire [31:0]   sr_result;
   wire [32:0]   sltu_result;

   ShiftRight sr(b,a[4:0],op==`ALU_SRL,sr_result);

   assign tmp=((op==`ALU_SUB)?~b+1:b);
   assign slt_result=a-b;
   assign sltu_result={1'b0,a}-{1'b0,b};

   assign c=(op==`ALU_ADD)?a+b:
            (op==`ALU_SUB)?a-b:
            (op==`ALU_OR)?a|b:
            (op==`ALU_AND)?a & b:
            (op==`ALU_XOR)?a ^ b:
            (op==`ALU_NOR)?~(a|b):
            (op==`ALU_SLL)?b<<a[4:0]:
            (op==`ALU_SRL||op==`ALU_SRA)?sr_result:
            (op==`ALU_SLT)?{31'd0,slt_result[31]}:
            (op==`ALU_SLTU)?{31'd0,sltu_result[32]}:
            32'hBBAACCDD;//for debug
   assign over=((op==`ALU_ADD || op==`ALU_SUB) &&
               a[31]==tmp[31] && tmp[31]==~c[31]);

endmodule
