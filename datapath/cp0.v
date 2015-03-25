`timescale 1ns/1ns

`define SR 5'd12
`define CAUSE 5'd13
`define EPC 5'd14
`define PRID 5'd15

//ExcCode Values
`define EC_INT 5'b00000

module cp0 (input         clk,
            input         rst,
            input [4:0]   a1,
            input [4:0]   a2,
            input [31:0]  din,
            input [31:0]  pc,
            input [6:2]   ExcCode,
            input [5:0]   HWInt,
            input         we,
            input         EXLSet,
            input         EXLClr,
            output        IntReq,
            output [31:0] EPC,
            output [31:0] dout
            );
   reg [15:10]            im;
   reg                    exl,ie;
   reg [15:10]            hwint_pend;
   reg [31:0]             _epc;
   reg [31:0]             PrId;
   reg [6:2]              _exccode;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         ie<=1;
         im<=6'b110000;
         exl<=0;
         hwint_pend<=0;
         PrId<=32'h12345678;
      end // if(rst)
      else begin
         hwint_pend<=HWInt;
         if (IntReq) begin
            _exccode<=ExcCode;
            _epc<=pc-4;
            exl<=1'b1;
         end // if(Int)
         else if (we) begin
            //SR
            if (a2==`SR) begin
               {im,exl,ie}<={din[15:10],EXLClr?1'b1:din[1],din[0]};
            end
            else if (a2==`EPC) begin
               _epc<=pc;
            end
            else if (EXLSet) begin
               exl<=1'b1;
            end // if(EXLSet)
            else if (EXLClr) begin
               exl<=1'b0;
            end
         end // if(we)
         else if (EXLSet) begin
            exl<=1'b1;
         end // if(EXLSet)
         else if (EXLClr) begin
            exl<=1'b0;
         end // if(EXLClr)
      end
   end
   assign dout=(a1==`SR)?{16'b0,im,8'b0,exl,ie}:
               (a1==`CAUSE)?{16'b0,hwint_pend,3'b0,_exccode,2'b00}:
               (a1==`EPC)?_epc:
               (a1==`PRID)?PrId:
               32'h0000_0000;
   assign EPC=_epc;
   assign IntReq=ie&&(!exl)&&(hwint_pend[15:10]&im[15:10]);


endmodule // cp0
