module controller (input [5:0]  OpCode,
                   input [5:0]  Funct,
                   output [1:0] RegDst,
                   output       ALUSrc,
                   output [1:0] MemToReg,
                   output       MemWrite,
                   output [1:0] ALUOp,
                   output [1:0] NPCOp,
                   output [1:0] ExtOp,
                   output       RegWrite,
                   output       JType);

   wire                         rtype;
   wire                         addu,subu,ori,lw,sw,beq,lui,jal,addi,slt,jr;

   assign rtype=(OpCode==6'b00_0000);
   assign addu=rtype&(Funct==6'b10_0001);
   assign subu=rtype&(Funct==6'b10_0011);
   assign ori=(OpCode==6'b00_1101);
   assign lw=(OpCode==6'b100_011);
   assign sw=(OpCode==6'b10_1011);
   assign beq=(OpCode==6'b00_0100);
   assign lui=(OpCode==6'b00_1111);
   assign jal=(OpCode==6'b00_0011);
   assign addi=(OpCode==6'b00_1000);
   assign slt=rtype&(Funct==6'b10_1010);
   assign jr=rtype&(Funct==6'b00_1000);
   assign addiu=(OpCode==6'b00_1001);
   assign j=(OpCode==6'b00_0010);

   assign RegDst=(ori|lw|lui|addi|addiu)?2'b00:
                 (addu|subu|slt)?2'b01:
                 2'b10;
   assign ALUSrc=(addu|subu|beq|slt|jr)?0:1;
   assign MemToReg=(addu|subu|ori|lui|addi|addiu)?2'b00:
                   (lw)?2'b01:
                   (slt)?2'b10:
                   2'b11;
   assign MemWrite=(sw)?1:0;
   assign ALUOp=(addu|lw|sw|addi|addiu)?2'b00:
                (subu|beq|slt)?2'b01:
                2'b10;
   assign NPCOp=(jal|j|jr)?2'b10:
                (beq)?2'b01:
                2'b00;
   assign ExtOp=(lw|sw|addi|addiu)?2'b01:
                (lui)?2'b10:
                2'b00;
   assign RegWrite=(sw|beq|jr)?0:1;
   assign JType=(jal|j)?0:1;

endmodule
