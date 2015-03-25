`include "ctldefine.v"

module ctl_id(input [31:0] instr,
              output [1:0] NPCOp,
              output [1:0] ExtOp,
              output       JType);
   wire                    `ALL_SUPPORT_INSTR;
   parse_instr parser(instr[`OP],instr[`FUNCT],`ALL_SUPPORT_INSTR);

   assign NPCOp=(jal|j|jr)?2'b10:
                (beq)?2'b01:
                2'b00;
   assign ExtOp=(lw|sw|addi|addiu)?2'b01:
                (lui)?2'b10:
                2'b00;
   assign JType=(jal|j)?0:1;

endmodule // ctl_id

module ctl_ex (input [31:0] instr,
               output       ALUSrc,
               output [2:0] ALUOp
               );
   wire                     `ALL_SUPPORT_INSTR;
   parse_instr parser(instr[`OP],instr[`FUNCT],`ALL_SUPPORT_INSTR);

   assign ALUSrc=(addu|subu|beq|slt|jr|sll|xor_r)?0:1;
   assign ALUOp=(addu|lw|sw|addi|addiu)?3'b000:
                (subu|beq|slt)?3'b001:
                (sll)?3'b011:
                (andi)?3'b100:
                (xor_r)?3'b101:
                3'b010;

endmodule // ctl_ex

module ctl_mem (input [31:0] instr,
                output MemWrite
                );
   wire                `ALL_SUPPORT_INSTR;
   parse_instr parser(instr[`OP],instr[`FUNCT],`ALL_SUPPORT_INSTR);

   assign MemWrite=(sw)?1:0;

endmodule // ctl_mem

module ctl_wb (input [31:0] instr,
               output [1:0] MemToReg,
               output       RegWrite,
               output [1:0] RegDst);
   wire                     `ALL_SUPPORT_INSTR;
   parse_instr parser(instr[`OP],instr[`FUNCT],`ALL_SUPPORT_INSTR);

   assign MemToReg=(addu|subu|xor_r|sll|ori|lui|addi|addiu|andi)?2'b00:
                   (lw)?2'b01:
                   (slt)?2'b10:
                   2'b11;
   assign RegWrite=(sw|beq|jr|j)?0:1;
   assign RegDst=(ori|lw|lui|addi|addiu|andi)?2'b00:
                 (addu|subu|slt|sll|xor_r)?2'b01:
                 2'b10;

endmodule // ctl_wb
