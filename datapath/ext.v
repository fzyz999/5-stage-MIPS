`timescale 1ns/1ns
module ext (op,din,dout);
   input [1:0]   op;
   input [15:0]  din;
   output [31:0] dout;

   assign dout=(op==2'b00)?{16'h0,din}:
               (op==2'b01&&din[15]==1'b1)?{16'hffff,din}:
               (op==2'b01&&din[15]==1'b0)?{16'h0,din}:
               {din,16'h0};

endmodule
