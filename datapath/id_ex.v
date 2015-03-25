`timescale 1ns/1ns
module id_ex (clk,rst,clear,instrD,immD,rd1D,rd2D,pcplusD,instrE,immE,rd1E,rd2E,pcplusE);
   input         clk,clear,rst;
   input [31:0]  instrD,immD,rd1D,rd2D,pcplusD;
   output [31:0] instrE,immE,rd1E,rd2E,pcplusE;

   reg [31:0]    _instr,_imm,_rd1,_rd2,_pcplus;

   always @(posedge clk or posedge rst) begin
        if (rst) begin
            _pcplus<=_pcplus<=32'h0000_3008;
            _instr<=32'h0;
            _imm<=32'h0;
         _rd1<=32'h0;
         _rd2<=32'h0;
        end
      else if (!clear) begin
         _instr<=instrD;
         _imm<=immD;
         _rd1<=rd1D;
         _rd2<=rd2D;
      end // if(clear)
      else begin
         _instr<=0;
         _imm<=0;
         _rd1<=0;
         _rd2<=0;
      end // else: !if(!clear)
      _pcplus<=pcplusD;
   end

   assign instrE=_instr;
   assign immE=_imm;
   assign rd1E=_rd1;
   assign rd2E=_rd2;
   assign pcplusE=_pcplus;

endmodule // id_ex
