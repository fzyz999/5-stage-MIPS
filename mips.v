`timescale 1ns/1ns
module mips(clk, rst);
   input        clk ;
   // clock
   input        rst ;
   // reset
   wire [31:0]  npc_pc;
   wire [31:0]  pc_im;
   wire [31:0]  instr,instrD,instrE,instrM,instrW;
   wire [1:0]   RegDst;
   wire         ALUSrc;
   wire [1:0]   MemToReg;
   wire         MemWrite;
   wire [1:0]   ALUOp;
   wire [1:0]   NPCOp;
   wire [1:0]   ExtOp;
   wire         RegWrite;
   wire         JType;
   wire [4:0]   regdst;
   wire [31:0]  pcD,pcplus,pcplusE,pcplusM,pcplusW;
   wire [31:0]  imm,immE;
   wire [31:0]  wd,rd1,rd2,rd1E,rd2E;
   wire [31:0]  alusrc,aluout,memout;
   wire [31:0]  ALUOutM;
   wire         zero,sign;
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

   if_id _if_id(clk,!stall,instr,pc_im,instrD,pcD);
   id_ex _id_ex(clk,stall,instrD,imm,FRSD,FRTD,instrE,rd1E,rd2E);
   ex_mem _ex_mem(clk,instrE,ALUOutE,WriteDataE,WriteRegE,
                  instrM,ALUOutM,WriteDataM,WriteRegM);
   mem_wb _mem_wb(clk,instrM,ReadDataM,ALUOutM,WriteRegM,
                  instrW,ReadDataW,ALUOutW,WriteRegW);

   pc _pc(npc_pc,clk,rst,pc_im);
   im_4k _im(pc_im[11:2],instr);
   controller _ctl(instr[31:26],instr[5:0],
                   RegDst,
                   ALUSrc,
                   MemToReg,
                   MemWrite,
                   ALUOp,
                   NPCOp,
                   ExtOp,
                   RegWrite,
                   JType);
   gpr _gpr(clk,rst,RegWrite,
            instr[25:21],
            instr[20:16],
            regdst,wd,rd1,rd2);
   alu _alu(rd1,alusrc,ALUOp,aluout,zero,sign);
   ext _ext(ExtOp,instr[15:0],imm);
   dm_4k _dm(aluout[11:2],rd2,MemWrite,clk,memout);
   npc _npc(real_npcop,pcD,instr[15:0],jtypeaddr,npc_pc,pcplus);

   assign regdst=(RegDst==2'b00)?instr[20:16]:
                 (RegDst==2'b01)?instr[15:11]:
                 31;
   assign alusrc=(ALUSrc==0)?rd2:imm;
   assign wd=(MemToReg==2'b00)?aluout:
             (MemToReg==2'b01)?memout:
             (MemToReg==2'b10)?{31'h0,sign}:
             pcplusW;
   assign jtypeaddr=(JType==0)?{pc_im[31:28],instr[25:0],2'b00}:
                    rd1;
   assign real_npcop=(NPCOp!=2'b01)?NPCOp:
                     (zero)?NPCOp:2'b00;

endmodule // mips
