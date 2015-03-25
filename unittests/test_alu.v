module test_alu (/*port details*/);
   reg  [31:0] i1,i2;
   reg  [1:0]  op;
   wire [31:0] dout;
   wire        zero,sign;

   alu a(i1,i2,op,dout,zero,sign);

   initial begin
      i1=32'd5;
      i2=32'd7;
      op=2'b00;
   end

   initial begin
      #10 op=2'b01;
      #10 op=2'b10;
      #200 $finish;
   end

   initial begin
      $monitor("i1=%h i2=%h op=%b dout=%h",i1,i2,op,dout);
   end

   initial begin
      $dumpfile("test_alu.lxt");
      $dumpvars(0,test_alu);
   end

endmodule
