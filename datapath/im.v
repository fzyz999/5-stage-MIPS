`timescale 1ns/1ns
module im_4k( addr, dout ) ;
   input [11:2]  addr ;
   // address bus
   output [31:0] dout ;

   // 32-bit memory output
   reg [31:0]    im[1023:0] ;

   assign dout=im[addr];

   initial begin
      $readmemh("code.txt",im);
   end

endmodule
