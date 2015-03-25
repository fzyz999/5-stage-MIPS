`define OP 31:26
`define RS 25:21
`define RT 20:16
`define RD 15:11
`define SHAMT 10:6
`define FUNCT 5:0
`define IMM 15:0
`define RTYPE 6'b00_0000

`define ADDU_R 6'b10_0001
`define SUBU_R 6'b10_0011
`define SLT_R 6'b10_1010
`define JR_R 6'b00_1000
`define SLL_R 6'b00_0000
`define XOR_R 6'b10_0110

`define ORI 6'b00_1101
`define LW 6'b100_011
`define SW 6'b10_1011
`define BEQ 6'b00_0100
`define LUI 6'b00_1111
`define JAL 6'b00_0011
`define ADDI 6'b00_1000
`define ADDIU 6'b00_1001
`define ANDI 6'b00_1100
`define J 6'b00_0010

`define ALL_SUPPORT_INSTR addu,subu,ori,lw,sw,beq,lui,jal,addi,slt,jr,addiu,j,sll,andi,xor_r

`ifndef CTLDEFINE_V
`define CTLDEFINE_V ctldefine

module parse_instr (input [5:0] OpCode,
                    input [5:0] Funct,
                    output      `ALL_SUPPORT_INSTR);
   wire                         rtype;

   assign rtype=(OpCode==`RTYPE);
   assign addu=rtype&(Funct==`ADDU_R);
   assign subu=rtype&(Funct==`SUBU_R);
   assign slt=rtype&(Funct==`SLT_R);
   assign jr=rtype&(Funct==`JR_R);
   assign sll=rtype&(Funct==`SLL_R);
   assign xor_r=rtype&(Funct==`XOR_R);

   assign ori=(OpCode==`ORI);
   assign lw=(OpCode==`LW);
   assign sw=(OpCode==`SW);
   assign beq=(OpCode==`BEQ);
   assign lui=(OpCode==`LUI);
   assign jal=(OpCode==`JAL);
   assign addi=(OpCode==`ADDI);
   assign addiu=(OpCode==`ADDIU);
   assign andi=(OpCode==`ANDI);
   assign j=(OpCode==`J);

endmodule // parse_instr

module processInstr (instr,cal_r,cal_i,ld,st,btype,jr_o,jal_o);
   input [31:0] instr;
   output       cal_r,cal_i,ld,st,btype,jr_o,jal_o;
   wire         `ALL_SUPPORT_INSTR;

   parse_instr parser(instr[`OP],instr[`FUNCT],`ALL_SUPPORT_INSTR);

   assign cal_r=addu|subu|slt|sll|xor_r;
   assign cal_i=ori|addi|addiu|lui|andi;
   assign ld=lw;
   assign st=sw;
   assign btype=beq;
   assign jr_o=jr;
   assign jal_o=jal;

endmodule // processInstr

`endif
