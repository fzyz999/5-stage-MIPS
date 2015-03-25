`include "ctldefine.v"
`include "aluop_def.v"
`include "cmpop_def.v"
`include "muldivop_def.v"

`timescale 1ns/1ns
module ctl_id(input [31:0] instr,
              output [1:0] NPCOp,
              output [1:0] ExtOp,
              output [2:0] CMPOp,
              output       CMPSrc,
              output       JType,
              output       isMFC0,
              output       isERET);
   wire                    `ALL_SUPPORT_INSTR;
   parse_instr parser(instr,`ALL_SUPPORT_INSTR);

   assign NPCOp=(jal|j|jr|jalr)?2'b10:
                (beq|bne|blez|bgtz|bltz|bgez)?2'b01:
                2'b00;
   assign ExtOp=(andi|ori|xori|slti|sltiu)?2'b00:
                (`LOAD|`STORE|addi|addiu)?2'b01:
                (lui)?2'b10:
                2'b00;//for safe
   assign CMPSrc=(beq|bne)?0:1;
   assign CMPOp=(beq)?`CMP_EQ:
                (bne)?`CMP_NE:
                (blez)?`CMP_LEZ:
                (bgtz)?`CMP_GTZ:
                (bltz)?`CMP_LTZ:
                `CMP_GEZ;
   assign JType=(jal|j)?0:1;
   assign isMFC0=mfc0;
   assign isERET=eret;

endmodule // ctl_id

module ctl_ex (input [31:0] instr,
               output       ShiftSrc,
               output       ALUSrc,
               output [3:0] ALUOp,
               output       hilo,
               output [1:0] MULDIVOp,
               output       MULDIVstart,
               output       HILOWe,
               output [1:0] EXOut,
               output       isERET_e
               );
   wire                     `ALL_SUPPORT_INSTR;
   parse_instr parser(instr,`ALL_SUPPORT_INSTR);

   assign ShiftSrc=(sll|srl|sra)?1:0;
   assign ALUSrc=(`CALC_R|jr|jalr|mfhi|mflo|mthi|mtlo)?0:1;
   assign ALUOp=(add|addu|lb|lbu|lh|lhu|lw|sb|sh|sw|addi|addiu)?`ALU_ADD:
                (sub|subu)?`ALU_SUB:
                (or_r|ori)?`ALU_OR:
                (and_r|andi)?`ALU_AND:
                (xor_r|xori)?`ALU_XOR:
                (nor_r)?`ALU_NOR:
                (sll|sllv)?`ALU_SLL:
                (srl|srlv)?`ALU_SRL:
                (sra|srav)?`ALU_SRA:
                (slt|slti)?`ALU_SLT:
                (sltu|sltiu)?`ALU_SLTU:
                `ALU_OR; //for safe
   assign hilo=(mthi)?1:0;
   assign HILOWe=(mthi|mtlo)?1:0;
   assign MULDIVstart=(mult|multu|div|divu)?1:0;
   assign MULDIVOp=(mult)?`SIGNED_MUL:
                   (multu)?`UNSIGNED_MUL:
                   (div)?`SIGNED_DIV:
                   `UNSIGNED_DIV;
   assign EXOut=(mfhi)?2'b10:
                (mflo)?2'b01:
                2'b00;
   assign isERET_e=eret;

endmodule // ctl_ex

module ctl_mem (input [31:0] instr,
                output [1:0] BEExtOp,
                output       CP0_WE,
                output       isERET_m
                );
   wire                `ALL_SUPPORT_INSTR;
   parse_instr parser(instr,`ALL_SUPPORT_INSTR);

   assign BEExtOp=(sw)?2'b00:
                  (sh)?2'b01:
                  (sb)?2'b10:
                  2'b11;
   assign CP0_WE=mtc0;
   assign isERET_m=eret;

endmodule // ctl_mem

module ctl_wb (input [31:0] instr,
               output [1:0] MemToReg,
               output       RegWrite,
               output [1:0] RegDst,
               output [2:0] EXTWbOp,
               output       BJ_W,
               output       isERET_w
               );
   wire                     `ALL_SUPPORT_INSTR;
   parse_instr parser(instr,`ALL_SUPPORT_INSTR);

   assign MemToReg=(`CALC_R|`CALC_I|mfhi|mflo|mfc0)?2'b00:
                   (`LOAD)?2'b01:
                   2'b10;
   assign RegWrite=(`STORE|`ALL_BTYPE|jr|j|mult|multu|div|divu|mthi|mtlo|mtc0|eret)?0:1;
   assign RegDst=(`CALC_I|`LOAD|mfc0)?2'b00:
                 (`CALC_R|mfhi|mflo|jalr)?2'b01:
                 2'b10;
   assign EXTWbOp=(lw)?3'b000:
                  (lhu)?3'b001:
                  (lh)?3'b010:
                  (lbu)?3'b011:
                  3'b100;
   assign BJ_W=`ALL_BTYPE|j|jr|jal|jalr;
   assign isERET_w=eret;

endmodule // ctl_wb
