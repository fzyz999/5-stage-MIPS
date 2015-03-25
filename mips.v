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
   wire         ShiftSrc,ALUSrc;
   wire [1:0]   MemToReg;
   wire [1:0]   BEExtOp;
   wire [3:0]   ALUOp;
   wire [2:0]   CMPOp;
   wire         CMPSrc;
   wire [1:0]   NPCOp;
   wire [1:0]   ExtOp;
   wire [2:0]   EXTWbOp;
   wire         RegWrite;
   wire         JType;
   wire [4:0]   regdst;
   wire [31:0]  imm,immE;
   wire [31:0]  wd,rd1,rd2,rd1E,rd2E;
   wire [31:0]  hi,lo;
   wire         hilo,MULDIVstart,HILOWe,busy;
   wire [1:0]   MULDIVOp;
   wire [31:0]  shiftsrc;
   wire [31:0]  alusrc,aluout,memout,exout,cmpsrc;
   wire [1:0]   EXOut;
   wire [31:0]  ALUOutM,ALUOutW;
   wire [31:0]  WriteDataM,WriteDataW;
   wire [31:0]  extwbout;
   wire [1:0]   memaddrE,memaddrW;
   wire         over,br;
   wire [31:0]  jtypeaddr;
   wire [1:0]   real_npcop;
   wire         stall;
   wire [3:0]   BE;

   //hazard
   hazard _hazard(instrD,instrE,instrM,MULDIVstart,busy,stall);

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
   im_4k _im(pc_im[11:2],instr);
   //---------------------------------
   if_id _if_id(clk,rst,!stall,instr,pcplus,instrD,pcplusD);

   assign regdst=(RegDst==2'b00)?instrW[20:16]:
                 (RegDst==2'b01)?instrW[15:11]:
                 31;
   assign real_npcop=(NPCOp!=2'b01)?NPCOp:
                     (br)?NPCOp:2'b00;
   assign pcD=pcplusD-4;
   assign jtypeaddr=(JType==0)?{pcD[31:28],instrD[25:0],2'b00}:
                    FRSD;
   assign cmpsrc=(CMPSrc?32'h0000_0000:FRTD);
   ctl_id _ctl_id(instrD,NPCOp,ExtOp,CMPOp,CMPSrc,JType);
   gpr _gpr(clk,rst,RegWrite,
            instrD[25:21],
            instrD[20:16],
            regdst,wd,rd1,rd2);
   cmp _cmp(FRSD,cmpsrc,CMPOp,br);
   ext _ext(ExtOp,instrD[15:0],imm);
   npc _npc(real_npcop,pcplus,pcplusD,instrD[15:0],jtypeaddr,npc_pc);
   //----------------------------------
   id_ex _id_ex(clk,rst,stall,instrD,imm,rd1,rd2,pcplusD+4,instrE,immE,rd1E,rd2E,pcplusE);
   assign alusrc=(ALUSrc==0)?FRTE:immE;
   assign shiftsrc=(ShiftSrc)?{{27{1'b0}},instrE[10:6]}:FRSE;
   assign exout=(EXOut==2'b01)?lo:
                (EXOut==2'b10)?hi:
                aluout;
   ctl_ex _ctl_ex(instrE,ShiftSrc,ALUSrc,ALUOp,hilo,MULDIVOp,MULDIVstart,HILOWe,EXOut);
   alu _alu(shiftsrc,alusrc,ALUOp,aluout,over);
   muldiv _muldiv(FRSE,FRTE,hilo,MULDIVOp,MULDIVstart,HILOWe,busy,hi,lo,clk,rst);
   //----------------------------------
   ex_mem _ex_mem(clk,rst,instrE,exout,FRTE,pcplusE,
                  instrM,ALUOutM,WriteDataM,pcplusM);
   assign memaddrE=ALUOutM[1:0];
   ctl_mem _ctl_mem(instrM,BEExtOp);
   beext _beext(ALUOutM[1:0],BEExtOp,BE);
   dm _dm(ALUOutM[12:2],FRTM,BE,clk,memout);
   //----------------------------------
   mem_wb _mem_wb(clk,rst,instrM,memaddrE,memout,ALUOutM,pcplusM,
                  instrW,memaddrW,WriteDataW,ALUOutW,pcplusW);
   ctl_wb _ctl_wb(instrW,MemToReg,RegWrite,RegDst,EXTWbOp);
   extwb _extwb(memaddrW,WriteDataW,EXTWbOp,extwbout);
   assign wd=(MemToReg==2'b00)?ALUOutW:
             (MemToReg==2'b01)?extwbout:
             pcplusW;

endmodule // mips
