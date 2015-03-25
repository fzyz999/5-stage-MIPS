`timescale 1ns/1ns

`include "ctldefine.v"

module hazard (instrD,instrE,instrM,start,busy,stall);
   input [31:0]  instrD,instrE,instrM;
   input         start,busy;
   output        stall;

   wire          cal_r_d,cal_i_d,jorb_d,brs_d,brt_d,jr_d,ld_d,st_d,jal_d,muldiv_d,mfc0_d,mtc0_d;
   wire          cal_r_e,cal_i_e,jorb_e,brs_e,brt_e,jr_e,st_e,ld_e,jal_e,muldiv_e,mfc0_e,mtc0_e;
   wire          cal_r_m,cal_i_m,jorb_m,brs_m,brt_m,jr_m,st_m,ld_m,jal_m,muldiv_m,mfc0_m,mtc0_m;

   processInstr pinstrD(instrD,cal_r_d,cal_i_d,ld_d,st_d,brs_d,brt_d,jr_d,jal_d,muldiv_d,mtc0_d,mfc0_d);
   processInstr pinstrE(instrE,cal_r_e,cal_i_e,ld_e,st_e,brs_e,brt_e,jr_e,jal_e,muldiv_e,mtc0_e,mfc0_e);
   processInstr pinstrM(instrM,cal_r_m,cal_i_m,ld_m,st_m,brs_m,brt_m,jr_m,jal_m,muldiv_m,mtc0_m,mfc0_m);

   assign jorb_d = brs_d | jr_d;
   assign jorb_e = brs_e | jr_e;
   assign jorb_m = brs_m | jr_m;

   wire          stall_jorb_rs,stall_b_rt,stall_cal_r,stall_cal_i,stall_ld,stall_st,stall_muldiv;

   assign stall_muldiv=muldiv_d & (start|busy);
   assign stall_jorb_rs = jorb_d & instrD[`RS]!= 5'b00000  &(
                               (cal_r_e & (instrD[`RS]==instrE[`RD])) |
                               (cal_i_e & (instrD[`RS]==instrE[`RT])) |
                               ((ld_e|mfc0_e) & (instrD[`RS]==instrE[`RT]))    |
                               ((ld_m|mfc0_m) & (instrD[`RS]==instrM[`RT]))
                               );
   assign stall_b_rt = brt_d & instrD[`RT]!= 5'b00000  &(
                               (cal_r_e & (instrD[`RT]==instrE[`RD])) |
                               (cal_i_e & (instrD[`RT]==instrE[`RT])) |
                               ((ld_e|mfc0_e) & (instrD[`RT]==instrE[`RT]))    |
                               ((ld_m|mfc0_m) & (instrD[`RT]==instrM[`RT]))
                               );
   assign stall_cal_r = cal_r_d & ((ld_e|mfc0_e) & (instrD[`RS]==instrE[`RT] | instrD[`RT]==instrE[`RT]));
   assign stall_cal_i = cal_i_d & ((ld_e|mfc0_e) & instrD[`RS]==instrE[`RT]);
   assign stall_ld = ld_d & ((ld_e|mfc0_e) & instrD[`RS]==instrE[`RT]);
   assign stall_st = st_d & ((ld_e|mfc0_e) & instrD[`RS]==instrE[`RT]);

   assign stall=stall_jorb_rs|stall_cal_r|stall_cal_i|stall_ld|stall_st|stall_b_rt|stall_muldiv;

endmodule // hazard
