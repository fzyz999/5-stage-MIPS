`timescale 1ns/1ns
module ext (op,din,dout);
   input [1:0]   op;
   input [15:0]  din;
   output [31:0] dout;

   assign dout=(op==2'b00)?{16'h0,din}:
               (op==2'b01&&din[15]==1'b1)?{16'hffff,din}:
               (op==2'b01&&din[15]==1'b0)?{16'h0000,din}:
               {din,16'h0};

endmodule

module beext (a1_0,op,be);
   input [1:0]  a1_0;
   input [1:0]  op;
   output [3:0] be;

   assign be=(op==2'b00)?4'b1111:
             (op==2'b01)?(a1_0[1]?4'b1100:4'b0011):
             (op==2'b10)?(
                          (a1_0==2'b00)?4'b0001:
                          (a1_0==2'b01)?4'b0010:
                          (a1_0==2'b10)?4'b0100:
                          4'b1000):
             4'b0000;

endmodule // beext

module ext16_wb (op,din,dout);
   input         op;
   input [15:0]  din;
   output [31:0] dout;

   assign dout=(op==1'b0)?{16'h0000,din}:
               {{16{din[15]}},din};

endmodule

module ext8_wb (op,din,dout);
   input         op;
   input [7:0]   din;
   output [31:0] dout;

   assign dout=(op==1'b0)?{24'h000000,din}:
               {{24{din[7]}},din};

endmodule

module extwb (a,din,op,dout);
   input [1:0]   a;
   input [31:0]  din;
   input [2:0]   op;
   output [31:0] dout;

   wire [15:0]   d16;
   wire [7:0]    d8;
   wire [31:0]   o16,o8;
   wire          _op;

   ext16_wb _ext16(_op,d16,o16);
   ext8_wb _ext8(_op,d8,o8);

   assign d16=a[1]?din[31:16]:din[15:0];
   assign d8=a[0]?d16[15:8]:d16[7:0];
   assign _op=(op==3'b010 | op==3'b100)?1:0;

   assign dout=(op==3'b000)?din:
               (op==3'b001|op==3'b010)?o16:
               (op==3'b011|op==3'b100)?o8:
               32'haabbccdd;//for debug

endmodule // extwb
