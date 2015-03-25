`timescale 1ns/1ns

module ex_mem (clk,rst,instrE,ALUOutE,WriteDataE,pcplusE,
               instrM,ALUOutM,WriteDataM,pcplusM);
   input         clk,rst;
   input [31:0]  instrE,ALUOutE,WriteDataE,pcplusE;
   output [31:0] instrM,ALUOutM,WriteDataM,pcplusM;

   reg [31:0]    _instr,_aluout,_writedata,_pcplus;

   always @(posedge clk or posedge rst) begin
        if (rst) begin
            _pcplus<=_pcplus<=32'h0000_3008;
            _instr<=32'h0;
            _aluout<=32'h0;
            _writedata<=32'h0;
        end
        else begin
            _instr<=instrE;
            _aluout<=ALUOutE;
            _writedata<=WriteDataE;
            _pcplus<=pcplusE;
        end
   end

   assign instrM=_instr;
   assign ALUOutM=_aluout;
   assign WriteDataM=_writedata;
   assign pcplusM=_pcplus;

endmodule // ex_mem
