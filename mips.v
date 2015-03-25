`timescale 1ns/1ns
module mips(clk, rst);
   input        clk ;
   // clock
   input        rst ;
   // reset
   wire [31:0]  npc_pc;
   wire [31:0]  pcplus,pcplusD,pcD,pcplusE,pcplusM,pcplusW;
   wire [31:0]  pc_im;
   wire [31:0]  instr,instrD,instrE,instrM,instrW;
   wire [1:0]   RegDst;
   wire         ALUSrc;
   wire [1:0]   MemToReg;
   wire         MemWrite;
   wire [2:0]   ALUOp;
   wire [1:0]   NPCOp;
   wire [1:0]   ExtOp;
   wire         RegWrite;
   wire         JType;
   wire [4:0]   regdst;
   wire [31:0]  imm,immE;
   wire [31:0]  wd,rd1,rd2,rd1E,rd2E;
   wire [31:0]  alusrc,aluout,memout;
   wire [31:0]  ALUOutM,ALUOutW;
   wire [31:0]  WriteDataM,WriteDataW;
   wire         zero,sign,cmp_zero,cmp_sign;
   wire [31:0]  jtypeaddr;
   wire [1:0]   real_npcop;
   wire         stall;

   //hazard
   hazard _hazard(instrD,instrE,instrM,stall);

   //forward_ctl
   wire [2:0]   ForwardRSD,ForwardRTD;
   wire [2:0]   ForwardRSE,ForwardRTE;
   wire [1:0]   ForwardRTM;
   forward_ctl _forward_ctl(instrD,instrE,instrM,instrW,
                            ForwardRSD,ForwardRTD,
                            ForwardRSE,ForwardRTE,
                            ForwardRTM);

   //muxs for forward
   wire [31:0]  FRSD,FRTD,FRSE,FRTE,FRTM;
   assign FRSD=(ForwardRSD==3'b000)?rd1:
               (ForwardRSD==3'b001)?ALUOutM:
               (ForwardRSD==3'b010)?wd:
               (ForwardRSD==3'b011)?pcplusM:
               pcplusW;
   assign FRTD=(ForwardRTD==3'b000)?rd2:
               (ForwardRTD==3'b001)?ALUOutM:
               (ForwardRTD==3'b010)?wd:
               (ForwardRTD==3'b011)?pcplusM:
               pcplusW;

   assign FRSE=(ForwardRSE==3'b000)?rd1E:
               (ForwardRSE==3'b001)?ALUOutM:
               (ForwardRSE==3'b010)?wd:
               (ForwardRSE==3'b011)?pcplusM:
               pcplusW;
   assign FRTE=(ForwardRTE==3'b000)?rd2E:
               (ForwardRTE==3'b001)?ALUOutM:
               (ForwardRTE==3'b010)?wd:
               (ForwardRTE==3'b011)?pcplusM:
               pcplusW;
   assign FRTM=(ForwardRTM==2'b00)?WriteDataM:
               (ForwardRTM==2'b01)?wd:
               pcplusW;

   pc _pc(clk,rst,!stall,npc_pc,pc_im,pcplus);
   im_4k _im(pc_im[9:2],instr);
   //---------------------------------
   if_id _if_id(clk,rst,!stall,instr,pcplus,instrD,pcplusD);

   assign regdst=(RegDst==2'b00)?instrW[20:16]:
                 (RegDst==2'b01)?instrW[15:11]:
                 31;
   assign real_npcop=(NPCOp!=2'b01)?NPCOp:
                     (cmp_zero)?NPCOp:2'b00;
   assign pcD=pcplusD-4;
   assign jtypeaddr=(JType==0)?{pcD[31:28],instrD[25:0],2'b00}:
                    FRSD;
   ctl_id _ctl_id(instrD,NPCOp,ExtOp,JType);
   gpr _gpr(clk,rst,RegWrite,
            instrD[25:21],
            instrD[20:16],
            regdst,wd,rd1,rd2);
   cmp _cmp(FRSD,FRTD,cmp_zero,cmp_sign);
   ext _ext(ExtOp,instrD[15:0],imm);
   npc _npc(real_npcop,pcplus,pcplusD,instrD[15:0],jtypeaddr,npc_pc);
   //----------------------------------
   id_ex _id_ex(clk,rst,stall,instrD,imm,rd1,rd2,pcplusD+4,instrE,immE,rd1E,rd2E,pcplusE);

   assign alusrc=(ALUSrc==0)?FRTE:immE;
   ctl_ex _ctl_ex(instrE,ALUSrc,ALUOp);
   alu _alu(FRSE,alusrc,ALUOp,instrE[10:6],aluout,zero,sign);
   //----------------------------------
   ex_mem _ex_mem(clk,rst,instrE,aluout,FRTE,pcplusE,
                  instrM,ALUOutM,WriteDataM,pcplusM);

   ctl_mem _ctl_mem(instrM,MemWrite);
   dm_4k _dm(ALUOutM[11:2],FRTM,MemWrite,clk,memout);

   mem_wb _mem_wb(clk,rst,instrM,memout,ALUOutM,pcplusM,
                  instrW,WriteDataW,ALUOutW,pcplusW);

   ctl_wb _ctl_wb(instrW,MemToReg,RegWrite,RegDst);
   assign wd=(MemToReg==2'b00)?ALUOutW:
             (MemToReg==2'b01)?WriteDataW:
             (MemToReg==2'b10)?{31'h0,sign}:
             pcplusW;

endmodule // mips
