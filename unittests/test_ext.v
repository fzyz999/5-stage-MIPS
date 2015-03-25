module test_ext (/*port details*/);
   reg  [15:0] din;
   reg  [1:0]  op;
   wire [31:0] dout;

   ext e(op,din,dout);

   initial begin
      din=16'd5;
      op=0;
   end

   initial begin
      #10 op=2'b01;
      #10 op=2'b10;
      #10 din=-16'd3;
      #10 op=2'b01;
      #10 op=2'b00;
   end

   initial begin
      $monitor("din=%h op=%b dout=%h",din,op,dout);
   end

   initial begin
      $dumpfile("test_ext.lxt");
      $dumpvars(0,test_ext);
   end

endmodule
