`include "ctldefine.v"

module hazard (instrD,instrE,instrM,stall);
   input [31:0]  instrD,instrE,instrM;
   output        stall;

   wire          cal_r_d,cal_i_d,jorb_d,btype_d,jr_d,ld_d,st_d,jal_d;
   wire          cal_r_e,cal_i_e,jorb_e,btype_e,jr_e,st_e,ld_e,jal_e;
   wire          cal_r_m,cal_i_m,jorb_m,btype_m,jr_m,st_m,ld_m,jal_m;

   processInstr pinstrD(instrD,cal_r_d,cal_i_d,ld_d,st_d,btype_d,jr_d,jal_d);
   processInstr pinstrE(instrE,cal_r_e,cal_i_e,ld_e,st_e,btype_e,jr_e,jal_e);
   processInstr pinstrM(instrM,cal_r_m,cal_i_m,ld_m,st_m,btype_m,jr_m,jal_m);

   assign jorb_d = btype_d | jr_d;
   assign jorb_e = btype_e | jr_e;
   assign jorb_m = btype_m | jr_m;

   wire          stall_jorb_rs,stall_b_rt,stall_cal_r,stall_cal_i,stall_ld,stall_st;

   assign stall_jorb_rs = jorb_d & instrD[`RS]!= 5'b00000  &(
                               (cal_r_e & (instrD[`RS]==instrE[`RD])) |
                               (cal_i_e & (instrD[`RS]==instrE[`RT])) |
                               (ld_e & (instrD[`RS]==instrE[`RT]))    |
                               (ld_m & (instrD[`RS]==instrM[`RT]))
                               );
   assign stall_b_rt = btype_d & instrD[`RT]!= 5'b00000  &(
                               (cal_r_e & (instrD[`RT]==instrE[`RD])) |
                               (cal_i_e & (instrD[`RT]==instrE[`RT])) |
                               (ld_e & (instrD[`RT]==instrE[`RT]))    |
                               (ld_m & (instrD[`RT]==instrM[`RT]))
                               );
   assign stall_cal_r = cal_r_d & (ld_e & (instrD[`RS]==instrE[`RT] | instrD[`RT]==instrE[`RT]));
   assign stall_cal_i = cal_i_d & (ld_e & instrD[`RS]==instrE[`RT]);
   assign stall_ld = ld_d & (ld_e & instrD[`RS]==instrE[`RT]);
   assign stall_st = st_d & (ld_e & instrD[`RS]==instrE[`RT]);

   assign stall=stall_jorb_rs|stall_cal_r|stall_cal_i|stall_ld|stall_st|stall_b_rt;

endmodule // hazard