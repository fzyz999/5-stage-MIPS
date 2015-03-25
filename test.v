module test_mips (/*port details*/);
   reg clk,rst;
   integer i;

   mips _mips(clk,rst);
   always #1 clk=~clk;

   initial begin
      clk=1;
      rst=1;
      #3 rst=0;
   end

   initial begin
      #10000 $finish;
   end

   initial begin
      #9999
        for (i=0; i!=1024; i=i+8) begin
           $display("%d %d %d %d %d %d %d %d",
               _mips._dm.dm[i],
               _mips._dm.dm[i+1],
               _mips._dm.dm[i+2],
               _mips._dm.dm[i+3],
               _mips._dm.dm[i+4],
               _mips._dm.dm[i+5],
               _mips._dm.dm[i+6],
               _mips._dm.dm[i+7]);
        end

   end


   initial begin
      $dumpfile("test.lxt");
      $dumpvars(0,test_mips);
   end

endmodule // test_mips
