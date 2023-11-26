//////////////////////////////////////////////////////////////////////////
// Filename: MultAddTree.sv
// Author:  Ther
// Date: 2023.11.23
// Note: mult-add tree, the interface is same as pe_array.sv
//////////////////////////////////////////////////////////////////////////

module MultAddTree # (
  parameter MAC_NUM_LOG2 =   4,  // log2 number of multiply-accumulation units. e.g. if the MAC number is 16, then MAC_NUM_LOG2 = 4
  parameter BW_ACT       =   8,  // bit length of activation
  parameter BW_WET       =   8,  // bit length of weight
  parameter BW_ACCU      =   32  // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  signed     [BW_ACT-1:0]    PE_act_in [(1 << MAC_NUM_LOG2)-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [(1 << MAC_NUM_LOG2)-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out
);
  localparam MAC_NUM = 1 << MAC_NUM_LOG2;
  localparam PE_MEDIUM_RESULT_REG = 2 * MAC_NUM - 1;

  reg signed [BW_ACT-1:0]    PE_act_in_reg [MAC_NUM-1:0];      // input buffer
  reg signed [BW_WET-1:0]    PE_wet_in_reg [MAC_NUM-1:0];      // weight buffer
  reg signed [BW_ACCU-1:0]   PE_result_medium_result_reg [PE_MEDIUM_RESULT_REG-1:0];
  reg PE_clear_acc_reg; // delay 1 cycle for control signal

  wire signed [BW_ACCU-1:0] PE_result_shift_temp;

  // control signal for clear accu
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      PE_clear_acc_reg <= 'b0;
    end
    else begin
      PE_clear_acc_reg <= PE_clear_acc;
    end
  end

  // buffer the activation
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      for (integer i = 0; i < MAC_NUM; i = i + 1) begin
        PE_act_in_reg[i] <= 'b0;
      end
    end
    else begin
      for (integer i = 0; i < MAC_NUM; i = i + 1) begin
        PE_act_in_reg[i] <= PE_act_in[i];
      end
    end
  end

  // buffer the weight
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      for (integer i = 0; i < MAC_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= 'b0;
      end
    end
    else begin
      for (integer i = 0; i < MAC_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= PE_wet_in[i];
      end
    end
  end

  // MAC tree logic -- multiply
  genvar gv_i;
  generate 
    for (gv_i = 0; gv_i < MAC_NUM; gv_i = gv_i + 1) begin : multiply
      always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin // reset to zero
          PE_result_medium_result_reg[gv_i] <= 'b0;
        end
        else if(~PE_mac_enable) begin // non-calculation time, keep the same
          PE_result_medium_result_reg[gv_i] <= PE_result_medium_result_reg[gv_i];
        end
        else if(PE_clear_acc_reg) begin
          PE_result_medium_result_reg[gv_i] <= 'b0;
        end
        else begin // multiply and accumulate
          PE_result_medium_result_reg[gv_i] <= PE_wet_in_reg[gv_i] * PE_act_in_reg[gv_i];
        end
      end 
    end
  endgenerate

  // MAC tree logic -- pipelined accumulate
  genvar stage;
  generate 
    for (stage = 0; stage <= MAC_NUM_LOG2; stage = stage + 1) begin : accumulate // note the last stage is accumulate the result into the output register
      localparam STAGE_INPUT_BEGIN_INDEX = (1 << MAC_NUM_LOG2) - (1 << (MAC_NUM_LOG2 - stage));
      localparam STAGE_OUTPUT_BEGIN_INDEX = (1 << MAC_NUM_LOG2) - (1 << (MAC_NUM_LOG2 - stage + 1));
      genvar gv_j;
      for (gv_j = 0; gv_j < STAGE_INPUT_NUM; gv_j = gv_j + 2) begin : line
        always @(posedge clk or negedge reset_n) begin
          if(~reset_n) begin // reset to zero
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j] <= 'b0;
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX+ gv_j + 1] <= 'b0;
          end
          else if(~PE_mac_enable) begin // non-calculation time, keep the same
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j] <= PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j];
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j + 1] <= PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j + 1];
          end
          else if(PE_clear_acc_reg) begin
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j] <= 'b0;
            PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j + 1] <= 'b0;
          end
          else begin // accumulate
            PE_result_medium_result_reg[STAGE_OUTPUT_BEGIN_INDEX + (gv_j >> 1)] <= PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j] + PE_result_medium_result_reg[STAGE_INPUT_BEGIN_INDEX + gv_j + 1];
          end
        end
      end
    end
  endgenerate

  // MAC tree logic -- combine the result
  assign PE_result_shift_temp = PE_result_medium_result_reg[MAC_NUM - 1] >>> PE_res_shift_num; // signed extension
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      PE_result_out <= 'b0;
    end
    else if(PE_result_shift_temp > 127) begin
      PE_result_out <= 127;
    end
    else if(PE_result_shift_temp < -128) begin
      PE_result_out <= -128;
    end
    else begin
      PE_result_out <= PE_result_out + PE_result_shift_temp[BW_ACT-1:0];  //截取低位
    end
  end

endmodule