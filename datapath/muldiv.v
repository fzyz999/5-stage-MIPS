`timescale 1ns/1ns

`include "muldivop_def.v"

module muldiv (d1,d2,hilo,op,start,we,busy,hi,lo,clk,rst);
   input [31:0]  d1,d2;
   input         hilo;
   input [1:0]   op;
   input         start,we,clk,rst;
   output        busy;
   output [31:0] hi,lo;

   reg [3:0]     i;
   reg           _busy;
   reg [63:0]    _hilo;
   reg [31:0]    _d1,_d2;
   reg [1:0]     _op;

   wire [63:0]   d164,d264;

   assign d164=(_op==`SIGNED_MUL|
                _op==`SIGNED_DIV)?
               {{32{_d1[31]}},_d1}:
               {32'h0000_0000,_d1};
   assign d264=(_op==`SIGNED_MUL|
                _op==`SIGNED_DIV)?
               {{32{_d2[31]}},_d2}:
               {32'h0000_0000,_d2};
   assign busy=_busy;
   assign hi=_hilo[63:32];
   assign lo=_hilo[31:0];

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         _busy<=0;
         _hilo<=64'h0000_0000_0000_0000;
         _d1<=0;
         _d2<=0;
         _op=2'b00;
      end // if(rst)
      else if (we) begin
         if (hilo) begin
            _hilo<={d1,_hilo[31:0]};
         end // if(hilo)
         else begin
            _hilo<={_hilo[63:32],d1};
         end
      end // if(we)
      else if (start) begin
         _busy<=1;
         _d1<=d1;
         _d2<=d2;
         _op<=op;
         i<=(op==`UNSIGNED_MUL|
            op==`SIGNED_MUL)?5:10;
      end // if(start)
      else if (i) begin
         i<=i-1;
      end // if(i)
      else begin
         _busy<=0;
         _hilo<=(_op==`UNSIGNED_MUL|
                 _op==`SIGNED_MUL)?d164*d264:
                (_op==`UNSIGNED_DIV)?{_d1%_d2,_d1/_d2}:
                {$signed(_d1)%$signed(_d2),$signed(_d1)/$signed(_d2)};
      end
   end

endmodule // muldiv
