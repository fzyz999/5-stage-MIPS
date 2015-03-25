`timescale 1ns/1ns
module dm( addr, wd, be, clk, rd ) ;
   input [12:2] addr ; // address bus
   input [31:0] wd ;
   // 32-bit input data
   input [3:0]  be ;
   // memory write enable
   input        clk ;
   // clock
   output [31:0] rd ; // 32-bit memory output

   reg [31:0]    _dm[2047:0] ;

   always @(posedge clk) begin
      if (be==4'b1111) begin
         _dm[addr]<=wd;
      end // if(be==4'b1111)
      else if (be==4'b0011) begin
         _dm[addr]<={_dm[addr][31:16],wd[15:0]};
      end // if(be==4'b0011)
      else if (be==4'b1100) begin
         _dm[addr]<={wd[15:0],_dm[addr][15:0]};
      end // if(be==4'b1100)
      else if (be==4'b0001) begin
         _dm[addr]<={_dm[addr][31:8],wd[7:0]};
      end // if(be==4'b0001)
      else if (be==4'b0010) begin
         _dm[addr]<={_dm[addr][31:16],wd[7:0],_dm[addr][7:0]};
      end // if(be==4'b0001)
      else if (be==4'b0100) begin
         _dm[addr]<={_dm[addr][31:24],wd[7:0],_dm[addr][15:0]};
      end // if(be==4'b0001)
      else if (be==4'b1000) begin
         _dm[addr]<={wd[7:0],_dm[addr][23:0]};
      end
   end

   assign rd = _dm[addr];

   initial begin
      $readmemh("data.txt",_dm);
   end

endmodule
