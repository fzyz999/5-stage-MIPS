`define OP 31:26
`define RS 25:21
`define RT 20:16
`define RD 15:11
`define SHAMT 10:6
`define FUNCT 5:0
`define IMM 15:0
`define RTYPE 6'b00_0000
`define REGIMM 6'b00_0001

`define ADDU_R 6'b10_0001
`define ADD_R 6'b10_0000
`define DIVU_R 6'b01_1011
`define DIV_R 6'b01_1010
`define JR_R 6'b00_1000
`define JALR_R 6'b00_1001
`define MULTU_R 6'b01_1001
`define MULT_R 6'b01_1000
`define SLLV_R 6'b00_0100
`define SLL_R 6'b00_0000
`define SLT_R 6'b10_1010
`define SLTU_R 6'b10_1011
`define SRAV_R 6'b00_0111
`define SRA_R 6'b00_0011
`define SRLV_R 6'b00_0110
`define SRL_R 6'b00_0010
`define SUBU_R 6'b10_0011
`define SUB_R 6'b10_0010

`define AND_R 6'b10_0100
`define OR_R 6'b10_0101
`define NOR_R 6'b10_0111
`define XOR_R 6'b10_0110

`define MFHI_R 6'b01_0000
`define MFLO_R 6'b01_0010
`define MTHI_R 6'b01_0001
`define MTLO_R 6'b01_0011

`define LB 6'b10_0000
`define LBU 6'b10_0100
`define LH 6'b10_0001
`define LHU 6'b10_0101
`define LW 6'b10_0011

`define SB 6'b10_1000
`define SH 6'b10_1001
`define SW 6'b10_1011

`define ADDI 6'b00_1000
`define ADDIU 6'b00_1001

`define ANDI 6'b00_1100
`define ORI 6'b00_1101
`define XORI 6'b00_1110

`define SLTI 6'b00_1010
`define SLTIU 6'b00_1011

`define BEQ 6'b00_0100
`define BNE 6'b00_0101
`define BLEZ 6'b00_0110
`define BGTZ 6'b00_0111

`define BLTZ 5'b00000
`define BGEZ 5'b00001

`define J 6'b00_0010
`define JAL 6'b00_0011

`define LUI 6'b00_1111

`define CALC_R (add|addu|sub|subu|sll|srl|sra|sllv|srlv|srav|and_r|or_r|nor_r|xor_r|slt|sltu)
`define CALC_I (addi|addiu|lui|andi|ori|xori|slti|sltiu)
`define LOAD (lb|lbu|lh|lhu|lw)
`define STORE (sb|sh|sw)
`define ALL_BTYPE (beq|bne|blez|bgtz|bltz|bgez)

`define ALL_SUPPORT_INSTR add,addu,sub,subu,mult,multu,div,divu,ori,lb,lbu,lh,lhu,lw,sb,sh,sw,beq,bne,blez,bgtz,bltz,bgez,lui,jal,jalr,addi,slt,slti,sltiu,sltu,jr,addiu,j,sll,srl,sra,sllv,srlv,srav,andi,xori,and_r,or_r,nor_r,xor_r,mfhi,mflo,mthi,mtlo

`ifndef CTLDEFINE_V
`define CTLDEFINE_V ctldefine

`timescale 1ns/1ns

module parse_instr (input [31:0] instr,
                    output      `ALL_SUPPORT_INSTR);
   wire                         rtype,regimm;

   wire [5:0]                  OpCode;
   wire [5:0]                  Funct;

   assign OpCode=instr[`OP];
   assign Funct=instr[`FUNCT];

   assign rtype=(OpCode==`RTYPE);
   assign add=rtype&(Funct==`ADD_R);
   assign addu=rtype&(Funct==`ADDU_R);
   assign sub=rtype&(Funct==`SUB_R);
   assign subu=rtype&(Funct==`SUBU_R);
   assign mult=rtype&(Funct==`MULT_R);
   assign multu=rtype&(Funct==`MULTU_R);
   assign div=rtype&(Funct==`DIV_R);
   assign divu=rtype&(Funct==`DIVU_R);

   assign slt=rtype&(Funct==`SLT_R);
   assign sltu=rtype&(Funct==`SLTU_R);

   assign sll=rtype&(Funct==`SLL_R);
   assign srl=rtype&(Funct==`SRL_R);
   assign sra=rtype&(Funct==`SRA_R);
   assign sllv=rtype&(Funct==`SLLV_R);
   assign srlv=rtype&(Funct==`SRLV_R);
   assign srav=rtype&(Funct==`SRAV_R);

   assign and_r=rtype&(Funct==`AND_R);
   assign or_r=rtype&(Funct==`OR_R);
   assign nor_r=rtype&(Funct==`NOR_R);
   assign xor_r=rtype&(Funct==`XOR_R);

   assign andi=(OpCode==`ANDI);
   assign ori=(OpCode==`ORI);
   assign lui=(OpCode==`LUI);
   assign xori=(OpCode==`XORI);

   assign lb=(OpCode==`LB);
   assign lbu=(OpCode==`LBU);
   assign lh=(OpCode==`LH);
   assign lhu=(OpCode==`LHU);
   assign lw=(OpCode==`LW);

   assign sb=(OpCode==`SB);
   assign sh=(OpCode==`SH);
   assign sw=(OpCode==`SW);

   assign slti=(OpCode==`SLTI);
   assign sltiu=(OpCode==`SLTIU);

   assign beq=(OpCode==`BEQ);
   assign bne=(OpCode==`BNE);
   assign blez=(OpCode==`BLEZ);
   assign bgtz=(OpCode==`BGTZ);

   assign regimm=(OpCode==`REGIMM);
   assign bltz=regimm&(instr[`RT]==`BLTZ);
   assign bgez=regimm&(instr[`RT]==`BGEZ);

   assign addi=(OpCode==`ADDI);
   assign addiu=(OpCode==`ADDIU);

   assign j=(OpCode==`J);
   assign jal=(OpCode==`JAL);
   assign jr=rtype&(Funct==`JR_R);
   assign jalr=rtype&(Funct==`JALR_R);

   assign mtlo=rtype&(Funct==`MTLO_R);
   assign mthi=rtype&(Funct==`MTHI_R);
   assign mflo=rtype&(Funct==`MFLO_R);
   assign mfhi=rtype&(Funct==`MFHI_R);

endmodule // parse_instr

module processInstr (instr,cal_r,cal_i,ld,st,brs,brt,jr_o,jal_o,muldiv);
   input [31:0] instr;
   output       cal_r,cal_i,ld,st,brs,brt,jr_o,jal_o,muldiv;
   wire         `ALL_SUPPORT_INSTR;

   parse_instr parser(instr,`ALL_SUPPORT_INSTR);

   assign cal_r=`CALC_R|mult|multu|div|divu|mfhi|mflo|jalr;
   assign cal_i=`CALC_I|mthi|mtlo;
   assign ld=`LOAD;
   assign st=`STORE;
   assign brt=beq|bne;
   assign brs=`ALL_BTYPE;
   assign jr_o=jr|jalr;
   assign jal_o=jal;
   assign muldiv=mult|multu|div|divu|mfhi|mflo|mthi|mtlo;

endmodule // processInstr

`endif
