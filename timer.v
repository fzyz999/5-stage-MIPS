`timescale 1ns/1ns

`define IDLE 2'b00
`define LOAD 2'b01
`define CNTING 2'b10
`define INT 2'b11

`define MODE_0 2'b00
`define MODE_1 2'b01

module coco_timer (clk_i,rst_i,add_i,we_i,dat_i,dat_o,irq);
   input [3:2]   add_i;
   input         clk_i,rst_i,we_i;
   input [31:0]  dat_i;
   output [31:0] dat_o;
   output        irq;

   reg [31:0]    count;
   reg [31:0]    preset;
   reg [31:0]    ctrl;
   reg           _irq;

   reg [1:0]     curr_state,next_state;

   assign dat_o=(add_i==2'b00)?ctrl:
                (add_i==2'b01)?preset:
                (add_i==2'b10)?count:
                32'h12345678;
   assign irq=_irq;

   always @(posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
         count<=31'h0000_0000;
         preset<=31'h0000_0000;
         ctrl<=31'h0000_0000;
         _irq<=0;
         curr_state<=`IDLE;
      end // if(rst)
      else if (we_i) begin
         if (add_i==2'b00) begin
            ctrl<=dat_i;
            curr_state<=next_state;
         end // if(dat_i)
         else if (add_i==2'b01) begin
            preset<=dat_i;
            _irq<=0;
            next_state<=`LOAD;
         end // if(add_i=2'b01)
         else if (add_i==2'b10) begin
            count<=dat_i;
            curr_state<=next_state;
         end
         else begin
            curr_state<=next_state;
         end
      end // if(we)
      else begin
         curr_state<=next_state;
      end
   end // always @ (posedge clk_i or posedge rst_i)

   always @(curr_state or ctrl or count) begin
      next_state=`IDLE;

      if (!ctrl[0]) begin
         next_state=`IDLE;
      end // if(ctrl[0])
      else begin
         case (curr_state)
           `IDLE: begin
              if (ctrl[2:1]==`MODE_1) begin
                 next_state=`LOAD;
              end // if(ctrl[2:1])
              //ctrl[2:1]==`MODE_0
              else if (ctrl[0] && count>1) begin
                 next_state=`CNTING;
              end
              else begin
                 next_state=`IDLE;
              end
           end // case: IDLE

           `LOAD: begin
              next_state=`CNTING;
           end

           `CNTING: begin
              if (count==1) begin
                 next_state=`INT;
              end // if(count==1)
              else begin
                 next_state=`CNTING;
              end
           end

           default: begin
              next_state=`IDLE;
           end
         endcase // case(curr_state)
      end
   end // always @ (curr_state)

   always @(posedge clk_i or posedge rst_i) begin
      case (next_state)
        `CNTING: begin
           count<=count-1;
        end

        `INT: begin
           _irq<=(ctrl[3]&&ctrl[2:1]==`MODE_0);
        end

        `LOAD: begin
           count<=preset;
           _irq<=0;
        end

        default: begin
           //do nothing
        end
      endcase // case(next_state)
   end



endmodule // cp0
