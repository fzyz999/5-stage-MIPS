module mem_wb (clk,rst,instrM,ReadDataM,ALUOutM,pcplusM,
               instrW,ReadDataW,ALUOutW,pcplusW);
   input         clk,rst;
   input [31:0]  instrM,ReadDataM,ALUOutM,pcplusM;
   output [31:0] instrW,ReadDataW,ALUOutW,pcplusW;

   reg [31:0]    _instr,_readdata,_aluout,_pcplus;

   always @(posedge clk or posedge rst) begin
		if (rst) begin
			_pcplus<=_pcplus<=32'h0000_3008;
			_instr<=32'h0;
			_readdata<=32'h0;
			_aluout<=32'h0;
		end
		else begin
			_instr<=instrM;
			_readdata<=ReadDataM;
			_aluout<=ALUOutM;
			_pcplus<=pcplusM;
		end
   end

   assign instrW=_instr;
   assign ReadDataW=_readdata;
   assign ALUOutW=_aluout;
   assign pcplusW=_pcplus;

endmodule // mem_wb
