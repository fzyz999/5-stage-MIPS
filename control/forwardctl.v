`timescale 1ns/1ns

`include "ctldefine.v"

module forward_ctl (instrD,instrE,instrM,instrW,
                    ForwardRSD,ForwardRTD,
                    ForwardRSE,ForwardRTE,
                    ForwardRTM);
   input [31:0]  instrD,instrE,instrM,instrW;
   output [2:0]  ForwardRSD,ForwardRTD;
   output [2:0]  ForwardRSE,ForwardRTE;
   output [1:0]  ForwardRTM;

   wire          cal_r_d,cal_i_d,jorb_d,brs_d,brt_d,jr_d,ld_d,st_d,jal_d,muldiv_d,mfc0_d,mtc0_d;
   wire          cal_r_e,cal_i_e,jorb_e,brs_e,brt_e,jr_e,st_e,ld_e,jal_e,muldiv_e,mfc0_e,mtc0_e;
   wire          cal_r_m,cal_i_m,jorb_m,brs_m,brt_m,jr_m,st_m,ld_m,jal_m,muldiv_m,mfc0_m,mtc0_m;
   wire          cal_r_w,cal_i_w,jorb_w,brs_w,brt_w,jr_w,st_w,ld_w,jal_w,muldiv_w,mfc0_w,mtc0_w;

   processInstr pinstrD(instrD,cal_r_d,cal_i_d,ld_d,st_d,brs_d,brt_d,jr_d,jal_d,muldiv_d,mtc0_d,mfc0_d);
   processInstr pinstrE(instrE,cal_r_e,cal_i_e,ld_e,st_e,brs_e,brt_e,jr_e,jal_e,muldiv_e,mtc0_e,mfc0_e);
   processInstr pinstrM(instrM,cal_r_m,cal_i_m,ld_m,st_m,brs_m,brt_m,jr_m,jal_m,muldiv_m,mtc0_m,mfc0_m);
   processInstr pinstrW(instrW,cal_r_w,cal_i_w,ld_w,st_w,brs_w,brt_w,jr_w,jal_w,muldiv_w,mtc0_w,mfc0_w);

   assign jorb_d = brs_d | jr_d;
   assign jorb_e = brs_d | jr_e;
   assign jorb_m = brs_d | jr_m;
   assign jorb_w = brs_d | jr_w;

   assign ForwardRSD = jorb_d & instrD[`RS]==5'h0 ? 0:
                       jorb_d & cal_r_m & instrD[`RS]==instrM[`RD] ? 1:
                       jorb_d & cal_i_m & instrD[`RS]==instrM[`RT] ? 1:
                       jorb_d & jal_m & instrD[`RS]==5'd31 ? 3:
                       jorb_d & cal_r_w & instrD[`RS]==instrW[`RD] ? 2:
                       jorb_d & cal_i_w & instrD[`RS]==instrW[`RT] ? 2:
                       jorb_d & (ld_w | mfc0_w) & instrD[`RS]==instrW[`RT] ? 2:
                       jorb_d & jal_w & instrD[`RS]==5'd31 ? 4:
                       0;

   assign ForwardRTD = brt_d & instrD[`RT]==5'h0 ? 0:
                       brt_d & cal_r_m & instrD[`RT]==instrM[`RD] ? 1:
                       brt_d & (cal_i_m | mfc0_m) & instrD[`RT]==instrM[`RT] ? 1:
                       brt_d & jal_m & instrD[`RT]==5'd31 ? 3:
                       brt_d & cal_r_w & instrD[`RT]==instrW[`RD] ? 2:
                       brt_d & (cal_i_w | mfc0_w) & instrD[`RT]==instrW[`RT] ? 2:
                       brt_d & ld_w & instrD[`RT]==instrW[`RT] ? 2:
                       brt_d & jal_w & instrD[`RT]==5'd31 ? 4:
                       0;

   assign ForwardRSE = (cal_r_e | cal_i_e | ld_e | st_e) & instrE[`RS]==5'h0 ? 0:
                       (cal_r_e | cal_i_e | ld_e | st_e) & cal_r_m & instrE[`RS]==instrM[`RD] ? 1:
                       (cal_r_e | cal_i_e | ld_e | st_e) & (cal_i_m | mfc0_m) & instrE[`RS]==instrM[`RT] ? 1:
                       (cal_r_e | cal_i_e | ld_e | st_e) & jal_m & instrE[`RS]==5'd31 ? 3:
                       (cal_r_e | cal_i_e | ld_e | st_e) & cal_r_w & instrE[`RS]==instrW[`RD] ? 2:
                       (cal_r_e | cal_i_e | ld_e | st_e) & (cal_i_w | mfc0_w) & instrE[`RS]==instrW[`RT] ? 2:
                       (cal_r_e | cal_i_e | ld_e | st_e) & ld_w & instrE[`RS]==instrW[`RT] ? 2:
                       (cal_r_e | cal_i_e | ld_e | st_e) & jal_w & instrE[`RS]==5'd31 ? 4:
                       0;

   assign ForwardRTE = (cal_r_e | st_e) & instrE[`RT]==5'h0 ? 0:
                       (cal_r_e | st_e) & cal_r_m & instrE[`RT]==instrM[`RD] ? 1:
                       (cal_r_e | st_e) & (cal_i_m | mfc0_m) & instrE[`RT]==instrM[`RT] ? 1:
                       (cal_r_e | st_e) & jal_m & instrE[`RT]==5'd31 ? 3:
                       (cal_r_e | st_e) & cal_r_w & instrE[`RT]==instrW[`RD] ? 2:
                       (cal_r_e | st_e) & (cal_i_w | mfc0_w) & instrE[`RT]==instrW[`RT] ? 2:
                       (cal_r_e | st_e) & ld_w & instrE[`RT]==instrW[`RT] ? 2:
                       (cal_r_e | st_e) & jal_w & instrE[`RT]==5'd31 ? 4:
                       0;

   assign ForwardRTM = (mtc0_m | st_m) & instrM[`RT]==5'h0 ? 0:
                       (mtc0_m | st_m) & cal_r_w & instrM[`RT]==instrW[`RD] ? 1:
                       (mtc0_m | st_m) & (cal_i_w | mfc0_w) & instrM[`RT]==instrW[`RT] ? 1:
                       (mtc0_m | st_m) & (ld_w | mfc0_w) & instrM[`RT]==instrW[`RT] ? 1:
                       (mtc0_m | st_m) & jal_w & instrM[`RT]==5'd31 ? 2:
                       0;

endmodule // forward_ctl
