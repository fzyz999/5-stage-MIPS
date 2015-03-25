`timescale 1ns/1ns
module if_id (clk,rst,enable,instr,pcplus,instrD,pcplusD);
   input         clk,enable,rst;
   input [31:0]  instr,pcplus;
   output [31:0] instrD;
   output [31:0] pcplusD;

   reg [31:0]    _instr;
   reg [31:0]    _pcplus;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         _pcplus<=32'h0000_3004;
         _instr<=32'h0000_0000;
      end // if(rst)
      else if (enable) begin
         _instr<=instr;
         _pcplus<=pcplus;
      end
   end

   assign instrD=_instr;
   assign pcplusD=_pcplus;

endmodule // if_id
