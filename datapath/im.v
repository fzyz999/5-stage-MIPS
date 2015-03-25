`timescale 1ns/1ns
module im_4k( addr, dout ) ;
   input [14:2]  addr ;
   // address bus
   output [31:0] dout ;

   // 32-bit memory output
   reg [31:0]    im[1023:0] ;
   reg [31:0]    exception_handler[1023:96];

   assign dout=(addr[14])?exception_handler[addr[11:2]]:im[addr[11:2]];

   initial begin
      $readmemh("code.txt",im);
      $readmemh("handler.txt",exception_handler);
   end

endmodule
