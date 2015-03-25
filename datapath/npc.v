`timescale 1ns/1ns
module signext (offset16,offset32);
   input [15:0]  offset16;
   output [31:0] offset32;

   assign offset32=offset16[15]?{14'h3fff,offset16,2'b00}:
                   {14'h0000,offset16,2'b00};

endmodule

module npc (npcop,pcplus,pcplusD,offset,absaddress,address);
   input [1:0]   npcop;
   input [31:0]  pcplusD,pcplus;
   input [15:0]  offset;
   input [31:0]  absaddress;
   output [31:0] address;

   wire [31:0]   offset32;

   signext ext(offset,offset32);

   assign address=(npcop==2'b00)?pcplus:
                  (npcop==2'b01)?pcplusD+offset32:
                  absaddress;

endmodule
