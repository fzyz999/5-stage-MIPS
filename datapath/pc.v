`timescale 1ns/1ns
module pc (npc,clk,reset,pc);
   input  [31:0]  npc;
   input          clk,reset;
   output [31:0]  pc;

   reg [31:0]     internal_pc;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         internal_pc<=32'h00003000;
      end // if(reset)
      else begin
         internal_pc<=npc;
      end
   end

   assign pc=internal_pc;

endmodule
