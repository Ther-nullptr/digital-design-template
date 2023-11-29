//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayv1.sv
// Author:  Ther
// Date: 2023.11.24
// Notee: A 1xN systolic array
//////////////////////////////////////////////////////////////////////////

module SystolicArrayv2 # (
  parameter MAC_NUM      =   10, // number of multiply-accumulation units, as #N
  parameter ACCU_NUM     =   5,  // size of systolic array, as #K
  parameter W_NUM        =   5,  // number of weights, as #W
  parameter BW_ACT       =   8,  // bit length of activation
  parameter BW_WET       =   8,  // bit length of weight
  parameter BW_ACCU      =   32  // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  signed     [BW_ACT-1:0]    PE_act_in [ACCU_NUM-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [W_NUM-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out [MAC_NUM-1:0]
);

  reg signed [BW_ACT-1:0]    PE_act_in_reg [ACCU_NUM-1:0];      // input buffer, only need #K
  reg signed [BW_WET-1:0]    PE_wet_in_reg;      // weight buffer
  reg signed [BW_ACCU-1:0]   PE_result_out_reg [MAC_NUM-1:0];
  reg [5:0] counter;

  reg PE_clear_acc_reg; // delay 1 cycle for control signal

  wire signed [BW_ACCU-1:0]  PE_internal_wire_temp [W_NUM-2:0][ACCU_NUM-2:0];
  wire signed [BW_ACCU-1:0]  PE_result_shift_temp [W_NUM-1:0];

  parameter CYCLE_BEGIN_SAVE = 10;

  // control signal for clear accu
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      PE_clear_acc_reg <= 'b0;
    end
    else begin
      PE_clear_acc_reg <= PE_clear_acc;
    end
  end

  // buffer all the weights
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      PE_wet_in_reg <= 'b0;
    end
    else begin
      PE_wet_in_reg <= PE_wet_in;
    end
  end

  // systolic array
  genvar systolic_i, systolic_j;
  generate
    for (systolic_i = 0; systolic_i < ACCU_NUM; systolic_i = systolic_i + 1) begin : systolic_i
     for (systolic_j = 0; systolic_j < W_NUM; systolic_j = systolic_j + 1) begin : systolic_j
      SystolicArrayv2 u_SystolicArrayv2;
     end
    end
  endgenerate

  // connect the wire
  for (systolic_i = 0; systolic_i < ACCU_NUM; systolic_i = systolic_i + 1) begin : systolic_i
    for (systolic_j = 0; systolic_j < W_NUM; systolic_j = systolic_j + 1) begin : systolic_j
      assign u_SystolicArrayv2.clk = clk;
      assign u_SystolicArrayv2.reset_n = reset_n;
      assign u_SystolicArrayv2.PE_mac_enable = PE_mac_enable;
      assign u_SystolicArrayv2.PE_clear_acc = PE_clear_acc_reg;

      // activation input
      if (systolic_j == 0) begin
        assign u_SystolicArrayv2.PE_act_in = PE_act_in_reg[systolic_i];
      end
      else begin
        assign u_SystolicArrayv2.PE_act_in = PE_internal_wire_temp[systolic_j][systolic_i-1];
      end

      // activation output
      if (systolic_j == W_NUM - 1) begin
        assign PE_result_shift_temp[systolic_j] = u_SystolicArrayv2.PE_below_out;
      end
      else begin
        assign PE_internal_wire_temp[systolic_j][systolic_i] = u_SystolicArrayv2.PE_below_out;
      end

      // above input
      if (systolic_i == 0) begin
        assign u_SystolicArrayv2.PE_above_in = PE_wet_in_reg;
      end
      else begin
        assign u_SystolicArrayv2.PE_above_in = PE_internal_wire_temp[systolic_j-1][systolic_i];
      end

      // below output
      if (systolic_i == ACCU_NUM - 1) begin
        assign u_SystolicArrayv2.PE_below_out = PE_result_shift_temp[systolic_j];
      end
      else begin
        assign u_SystolicArrayv2.PE_below_out = PE_internal_wire_temp[systolic_j][systolic_i];
      end
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      counter <= 0;
      for (integer i = 0; i < MAC_NUM; i = i + 1) begin
        PE_result_out[i] <= 'b0;
      end
    end
    else begin
      counter <= counter + 1;
      if (counter >= CYCLE_BEGIN_SAVE and counter < CYCLE_BEGIN_SAVE + MAC_NUM) begin
        PE_result_out[counter - CYCLE_BEGIN_SAVE] <= PE_result_shift_temp[BW_ACT-1:0];
      end
    end
  end

endmodule