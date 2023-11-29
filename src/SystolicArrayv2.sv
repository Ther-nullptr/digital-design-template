//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayv1.sv
// Author:  Ther
// Date: 2023.11.24
// Notee: A 1xN systolic array
//////////////////////////////////////////////////////////////////////////

module SystolicArrayv1 # (
  parameter MAC_NUM      =   10, // number of multiply-accumulation units, as #N
  parameter ACCU_NUM     =   5,  // size of systolic array, as #K
  parameter BW_ACT       =   8,  // bit length of activation
  parameter BW_WET       =   8,  // bit length of weight
  parameter BW_ACCU      =   32  // bit length of accu result
  parameter ARCH_TYPE    =   0   // 0: arch 0, 1: arch 1
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  PE_load_weight,
  input  signed     [BW_ACT-1:0]    PE_act_in [MAC_NUM-1:0][ACCU_NUM-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [ACCU_NUM-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out [MAC_NUM-1:0]
);
  reg signed [BW_ACT-1:0]    PE_act_in_reg [ACCU_NUM-1:0];      // input buffer, only need #K
  reg signed [BW_ACCU-1:0]   PE_result_medium_result_reg [PE_MEDIUM_RESULT_REG-1:0];
  reg [5:0] counter;
  reg PE_clear_acc_reg; // delay 1 cycle for control signal

  // control signal for clear accu
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      PE_clear_acc_reg <= 'b0;
    end
    else begin
      PE_clear_acc_reg <= PE_clear_acc;
    end
  end

  genvar systolic_i;
  generate
    for (systolic_i = 0; systolic_i < ACCU_NUM; systolic_i = systolic_i + 1) begin : systolic
      if (systolic_i == 0) begin
        SystolicArrayPEv1(
          .clk(clk),
          .reset_n(reset_n),
          .PE_mac_enable(PE_mac_enable),
          .PE_clear_weight(1'b0),
          .weight_load_en(PE_load_weight),
          .PE_act_in(PE_act_in_reg[systolic_i]),
          .PE_above_in(PE_wet_in_reg),
          .PE_below_out(PE_internal_wire_temp[systolic_i])
        );
      end
      else if (systolic_i < ACCU_NUM - 1) begin
        SystolicArrayPEv1(
          .clk(clk),
          .reset_n(reset_n),
          .PE_mac_enable(PE_mac_enable),
          .PE_clear_weight(1'b0),
          .weight_load_en(PE_load_weight),
          .PE_act_in(PE_act_in_reg[systolic_i]),
          .PE_above_in(PE_internal_wire_temp[systolic_i - 1]),
          .PE_below_out(PE_internal_wire_temp[systolic_i])
        );        
      end
      else begin
        SystolicArrayPEv1(
          .clk(clk),
          .reset_n(reset_n),
          .PE_mac_enable(PE_mac_enable),
          .PE_clear_weight(1'b0),
          .weight_load_en(PE_load_weight),
          .PE_act_in(PE_act_in_reg[systolic_i]),
          .PE_above_in(PE_internal_wire_temp[systolic_i - 1]),
          .PE_below_out(PE_result_shift_temp)
        );
      end
    end    
  endgenerate

endmodule