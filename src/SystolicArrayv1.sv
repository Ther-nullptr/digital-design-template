//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayv1.sv
// Author:  Ther
// Date: 2023.11.24
// Notee: A 1xN systolic array
//////////////////////////////////////////////////////////////////////////

module SystolicArrayv1 # (
  parameter MAC_NUM      =   10, // log2 number of multiply-accumulation units. e.g. if the MAC number is 16, then MAC_NUM_LOG2 = 4
  parameter BW_ACT       =   8,  // bit length of activation
  parameter BW_WET       =   8,  // bit length of weight
  parameter BW_ACCU      =   32  // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  signed     [BW_ACT-1:0]    PE_act_in [MAC_NUM-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [MAC_NUM-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out
);
  reg signed [BW_ACT-1:0]    PE_act_in_reg [MAC_NUM-1:0];      // input buffer
  reg signed [BW_WET-1:0]    PE_wet_in_reg [MAC_NUM-1:0];      // weight buffer
  reg signed [BW_ACCU-1:0]   PE_result_medium_result_reg [PE_MEDIUM_RESULT_REG-1:0];
  reg PE_clear_acc_reg; // delay 1 cycle for control signal

  localparam LOG_MAC_NUM = $clog2(MAC_NUM);
  reg [LOG_MAC_NUM:0] counter;

  // control signal for clear accu
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      PE_clear_acc_reg <= 'b0;
    end
    else begin
      PE_clear_acc_reg <= PE_clear_acc;
    end
  end

  // 

endmodule