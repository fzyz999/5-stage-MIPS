`timescale 1ns/1ns
module gpr (clk,reset,we,a1,a2,a3,wd,rd1,rd2);
   input [4:0]   a1,a2,a3;
   input [31:0]  wd;
   input         clk,reset,we;
   output [31:0] rd1,rd2;

   reg [31:0]    g[31:0];
   integer       i;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         for (i=0; i!=32; i=i+1)
            g[i]<=0;
      end // if(reset)
      else if (we) begin
         if(a3) begin
            g[a3]<=wd;
            $display("%d %x",a3,wd);
         end
      end // if(we)
   end

   assign rd1=(we & a1==a3 & a3!=0)?wd:
              g[a1];
   assign rd2=(we & a2==a3 & a3!=0)?wd:
              g[a2];

endmodule
