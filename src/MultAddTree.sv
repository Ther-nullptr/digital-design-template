//////////////////////////////////////////////////////////////////////////
// Filename: MultAddTree.sv
// Author:  Ther
// Date: 2023.11.23
// Note: mult-add tree, the interface is same as pe_array.sv
//////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module MultAddTree # (
  parameter MAC_NUM             =   10, // number of multiply-accumulation units
  parameter ACCU_NUM_LOG2       =   4,  // log2 number of multiply-accumulation units. e.g. if the MAC number is 16, then ACCU_NUM_LOG2 = 4
  parameter BW_ACT              =   8,  // bit length of activation
  parameter BW_WET              =   8,  // bit length of weight
  parameter BW_ACCU             =   32, // bit length of accu result
  localparam ACCU_NUM           =   (1 << ACCU_NUM_LOG2)
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  signed     [BW_ACT-1:0]    PE_act_in [MAC_NUM-1:0][ACCU_NUM-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [ACCU_NUM-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out [MAC_NUM-1:0]
);

  localparam PE_MEDIUM_RESULT_REG = 2 * ACCU_NUM - 1;

  reg signed [BW_ACT-1:0]    PE_act_in_reg [MAC_NUM-1:0][ACCU_NUM-1:0];      // input buffer
  reg signed [BW_WET-1:0]    PE_wet_in_reg [ACCU_NUM-1:0];      // weight buffer
  reg signed [BW_ACCU-1:0]   PE_result_medium_result_reg [MAC_NUM-1:0][PE_MEDIUM_RESULT_REG-1:0];
  reg signed [BW_ACCU-1:0]   PE_result_out_reg [MAC_NUM-1:0];
  reg PE_clear_acc_reg; // delay 1 cycle for control signal

  // only for waveform
  genvar i,j;
  generate
    for (i = 0; i < MAC_NUM; i = i + 1) begin : medium_result
      for (j = 0; j < PE_MEDIUM_RESULT_REG; j = j + 1) begin : medium_result_inside
        wire signed [BW_ACCU-1:0] PE_result_medium_result_reg_tmp;
        assign PE_result_medium_result_reg_tmp = PE_result_medium_result_reg[i][j];
      end
    end
  endgenerate

  genvar gv_weight;
  generate
    for (gv_weight = 0; gv_weight < ACCU_NUM; gv_weight = gv_weight + 1) begin : wet_in
        wire signed [BW_WET-1:0] PE_wet_in_tmp;
        assign PE_wet_in_tmp = PE_wet_in_reg[gv_weight];
    end
  endgenerate

  genvar gv_input, accu_i;
  generate
    for (gv_input = 0; gv_input < MAC_NUM; gv_input = gv_input + 1) begin : act_in
        for (accu_i = 0; accu_i < ACCU_NUM; accu_i = accu_i + 1) begin : accu
            wire signed [BW_ACT-1:0] PE_act_in_tmp;
            assign PE_act_in_tmp = PE_act_in_reg[gv_input][accu_i];
        end
    end
  endgenerate

  genvar gv_output;
  generate
    for (gv_output = 0; gv_output < MAC_NUM; gv_output = gv_output + 1) begin : act_output
        wire signed [BW_ACT-1:0] PE_result_out_tmp;
        assign PE_result_out_tmp = PE_result_out[gv_output];
    end
  endgenerate

  // control signal for clear accu, delay for 2log2(ACCU_NUM) + 1 cycles
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      PE_clear_acc_reg <= 'b0;
    end
    else begin
      PE_clear_acc_reg <= PE_clear_acc;
    end
  end

  // buffer the weight
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      for (integer i = 0; i < ACCU_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= 'b0;
      end
    end
    else begin
      for (integer i = 0; i < ACCU_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= PE_wet_in[i];
      end
    end
  end

  // # MAC_NUM trees
  genvar gv_i, buffer_i, mult_i, stage, gv_j;
  generate
    for (gv_i = 0; gv_i < MAC_NUM; gv_i = gv_i + 1) begin : line
      wire signed [BW_ACCU-1:0] PE_result_shift_temp;

      // buffer the activation
      for (buffer_i = 0; buffer_i < ACCU_NUM; buffer_i = buffer_i + 1) begin : buffer
        always @(posedge clk or negedge reset_n) begin
          if(~reset_n) begin // reset to zero
            PE_act_in_reg[gv_i][buffer_i] <= 'b0;
          end
          else begin
            PE_act_in_reg[gv_i][buffer_i] <= PE_act_in[gv_i][buffer_i];
          end
        end
      end

      // MAC tree logic -- multiply
      for (mult_i = 0; mult_i < ACCU_NUM; mult_i = mult_i + 1) begin : multiply
        always @(posedge clk or negedge reset_n) begin
          if(~reset_n) begin // reset to zero
            PE_result_medium_result_reg[gv_i][mult_i] <= 'b0;
          end
          else if(~PE_mac_enable) begin // non-calculation time, keep the same
            PE_result_medium_result_reg[gv_i][mult_i] <= PE_result_medium_result_reg[gv_i][mult_i];
          end
          else if(PE_clear_acc_reg) begin // clear the result
            PE_result_medium_result_reg[gv_i][mult_i] <= 'b0;
          end
          else begin // multiply and accumulate
            PE_result_medium_result_reg[gv_i][mult_i] <= PE_wet_in_reg[mult_i] * PE_act_in_reg[gv_i][mult_i];
          end
        end 
      end

      // MAC tree logic -- pipelined accumulate
      for (stage = 0; stage < ACCU_NUM_LOG2; stage = stage + 1) begin : accumulate // note the last stage is accumulate the result into the output register
        localparam STAGE_INPUT_BEGIN_INDEX = (1 << (ACCU_NUM_LOG2 + 1)) - (1 << ((ACCU_NUM_LOG2 + 1) - stage));
        localparam STAGE_OUTPUT_BEGIN_INDEX = (1 << (ACCU_NUM_LOG2 + 1)) - (1 << ((ACCU_NUM_LOG2 + 1) - (stage + 1)));
        localparam STAGE_INPUT_NUM = (1 << (ACCU_NUM_LOG2 - stage));
          for (gv_j = 0; gv_j < STAGE_INPUT_NUM; gv_j = gv_j + 2) begin : stage_inside
            always @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin // reset to zero
              // clear all the intermediate result 
              PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j] <= 'b0;
              PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j + 1] <= 'b0;
              PE_result_medium_result_reg[gv_i][STAGE_OUTPUT_BEGIN_INDEX + (gv_j >> 1)] <= 'b0;
            end
            else if(~PE_mac_enable) begin // non-calculation time, keep the same
              PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j] <= PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j];
              PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j + 1] <= PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j + 1];
            end
            else begin // accumulate
              PE_result_medium_result_reg[gv_i][STAGE_OUTPUT_BEGIN_INDEX + (gv_j >> 1)] <= PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j] + PE_result_medium_result_reg[gv_i][STAGE_INPUT_BEGIN_INDEX + gv_j + 1];
            end
          end
        end
      end

      // MAC tree logic -- combine the result
      // assign PE_result_shift_temp = PE_result_medium_result_reg[gv_i][(ACCU_NUM - 1) << 1]; // >>> PE_res_shift_num; // signed extension
      always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin // reset to zero
          PE_result_out_reg[gv_i] <= 'b0;
        end
        else if (PE_clear_acc_reg) begin
          PE_result_out_reg[gv_i] <= 'b0;
          for (integer i = 0; i < PE_MEDIUM_RESULT_REG; i = i + 1) begin
            PE_result_medium_result_reg[gv_i][i] <= 'b0;
          end
        end
        else begin
          PE_result_out_reg[gv_i] <= PE_result_out_reg[gv_i] + PE_result_medium_result_reg[gv_i][(ACCU_NUM - 1) << 1];  //截取低位
        end
      end

      // MAC tree logic -- output
      assign PE_result_shift_temp = PE_result_out_reg[gv_i] >>> PE_res_shift_num; // signed extension
      always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
          PE_result_out[gv_i] <= 'b0;
        end
        else if(PE_result_shift_temp > 127) begin
          PE_result_out[gv_i] <= 127;
        end
        else if(PE_result_shift_temp < -128) begin
          PE_result_out[gv_i] <= -128;
        end
        else begin
          PE_result_out[gv_i] <= PE_result_shift_temp;
        end
      end
    end
  endgenerate
endmodule