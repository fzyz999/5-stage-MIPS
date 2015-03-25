module test_gpr (/*port details*/);
   reg clk,we,reset;
   reg [4:0] addr,addr2;
   reg [31:0] data;
   wire [31:0] dout,dout2;

   gpr g(clk,reset,we,addr,addr2,addr2,data,dout,dout2);

   initial begin
      we=1;
      reset=1;
      clk=0;
      addr=0;
      addr2=0;
      data=5;
      #20 reset=0;
   end

   always #5 clk=~clk;

   always @(negedge clk) begin
      we=~we;
      data<=data+1;
      if (we) begin
         addr2<=addr;
         addr<=addr+1;
      end // if(we)
   end

   initial begin
      #200 $finish;
   end

   initial begin
      $monitor("time %t we %d addr %d dout %d dout2 %d",$time,we,addr,dout,dout2);
   end

   initial begin
      $dumpfile("test_gpr.lxt");
      $dumpvars(0,test_gpr);
   end
endmodule
