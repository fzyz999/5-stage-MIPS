`timescale 1ns/1ns
module mem_wb (clk,rst,instrM,MemAddrE,ReadDataM,ALUOutM,pcplusM,
               instrW,MemAddrW,ReadDataW,ALUOutW,pcplusW);
   input         clk,rst;
   input [31:0]  instrM,ReadDataM,ALUOutM,pcplusM;
   input [1:0]   MemAddrE;
   output [1:0]  MemAddrW;
   output [31:0] instrW,ReadDataW,ALUOutW,pcplusW;

   reg [31:0]    _instr,_readdata,_aluout,_pcplus;
   reg [1:0]     _memaddr;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         _instr<=32'h0;
         _readdata<=32'h0;
         _aluout<=32'h0;
         _memaddr<=2'b0;
         _pcplus<=pcplusM;
      end
      else begin
         _instr<=instrM;
         _readdata<=ReadDataM;
         _aluout<=ALUOutM;
         _pcplus<=pcplusM;
         _memaddr<=MemAddrE;
      end
   end

   assign instrW=_instr;
   assign ReadDataW=_readdata;
   assign ALUOutW=_aluout;
   assign pcplusW=_pcplus;
   assign MemAddrW=_memaddr;

endmodule // mem_wb
