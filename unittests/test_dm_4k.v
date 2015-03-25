module test_dm_4k (/*port details*/);
   reg clk,we;
   reg [9:0] addr;
   reg [31:0] data;
   wire [31:0] dout;

   dm_4k dm(addr,data,we,clk,dout);

   initial begin
      we=1;
      clk=0;
      addr=0;
      data=0;
   end


   always #5 clk=~clk;

   always @(negedge clk) begin
      we=~we;
      data<=data+1;
      if (we) begin
         addr<=addr+4;
      end // if(we)
   end

   initial begin
      #200 $finish;
   end

   initial begin
      $monitor("time %t we %d addr %d dout %d",$time,we,addr,dout);
   end

   initial begin
      $dumpfile("test_dm_4k.lxt");
      $dumpvars(0,test_dm_4k);
   end


endmodule
