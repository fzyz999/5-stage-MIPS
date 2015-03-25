module test_pc (/*port details*/);
   wire [31:2] instr;
   reg [31:2]  npc;
   reg         clk,reset;

   pc _pc(npc,clk,reset,instr);

   initial begin
      clk=0;
      npc=0;
      reset=1;
      #7 reset=0;
   end

   always #5 clk=~clk;
   always #30 reset=~reset;

   always @(negedge clk) begin
      npc<=npc+4;
   end

   initial begin
      #200 $finish;
   end

   initial begin
      $monitor("time %t reset %d npc %x instr %x",$time,reset,npc,instr);
   end

   initial begin
      $dumpfile("test_pc.lxt");
      $dumpvars(0,test_pc);
   end


endmodule
