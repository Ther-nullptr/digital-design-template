//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayv2.sv
// Author:  Ther
// Date: 2023.12.1
// Notee: A MxN systolic array
//////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module SystolicArrayv2 # (
  parameter BM_NUM       =   4,  // weight buffer bandwidth, as #M
  parameter BN_NUM       =   4,  // number of multiply-accumulation units, as #N
  parameter ACCU_NUM     =   5,  // size of systolic array, as #K
  parameter BW_ACT       =   8,  // bit length of activation
  parameter BW_WET       =   8,  // bit length of weight
  parameter BW_ACCU      =   32  // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_acc,
  input  PE_weight_partial_sel,
  input  signed     [BW_ACT-1:0]    PE_act_in [ACCU_NUM-1:0],
  input  signed     [BW_WET-1:0]    PE_wet_in [BM_NUM-1:0],
  input             [7:0]           PE_res_shift_num,
  output reg signed [BW_ACT-1:0]    PE_result_out [BM_NUM-1:0][BN_NUM-1:0]
);

  localparam COUNTER_MAX_BITWIDTH = $clog2(ACCU_NUM + BN_NUM + BM_NUM) + 1;

  reg signed [BW_ACT-1:0]    PE_act_in_reg [ACCU_NUM-1:0];    // input buffer, only need #K
  reg signed [BW_WET-1:0]    PE_wet_in_reg [BM_NUM-1:0];      // weight buffer
  reg signed [BW_ACCU-1:0]   PE_result_out_reg [BM_NUM-1:0][BN_NUM-1:0];
  reg signed [BW_ACCU-1:0]   PE_result_out_reg_accumulate [BM_NUM-1:0][BN_NUM-1:0];
  reg [COUNTER_MAX_BITWIDTH-1:0] counter [BM_NUM-1:0];

  wire signed [BW_ACCU-1:0]  PE_internal_wire_temp_accu [BM_NUM-1:0][ACCU_NUM:0];
  wire signed [BW_ACT-1:0]   PE_internal_wire_temp_act [ACCU_NUM-1:0][BM_NUM:0];
  wire signed [BW_ACCU-1:0]  PE_result_out_part_temp [BM_NUM-1:0];

  reg PE_weight_partial_sel_reg [BM_NUM-1:0]; // last cycle's PE_weight_partial_sel
  wire PE_weight_partial_sel_true_val [BM_NUM:0]; // the delayed PE_weight_partial_sel to control different column of systolic array

  assign PE_weight_partial_sel_true_val[0] = PE_weight_partial_sel;
  genvar PE_weight_partial_sel_i;
  generate
    for (PE_weight_partial_sel_i = 0; PE_weight_partial_sel_i < BM_NUM; PE_weight_partial_sel_i = PE_weight_partial_sel_i + 1) begin : PE_weight_partial_sel_gen
      assign PE_weight_partial_sel_true_val[PE_weight_partial_sel_i+1] = PE_weight_partial_sel_reg[PE_weight_partial_sel_i];
    end
  endgenerate

  reg PE_clear_acc_reg [BM_NUM-2:0]; // delay 1 cycle for control signal
  wire PE_clear_acc_true_val [BM_NUM-1:0]; // the delayed PE_clear_acc to control different column of systolic array

  assign PE_clear_acc_true_val[0] = PE_clear_acc;
  genvar PE_clear_acc_true_val_i;
  generate
    for (PE_clear_acc_true_val_i = 0; PE_clear_acc_true_val_i < BM_NUM-1; PE_clear_acc_true_val_i = PE_clear_acc_true_val_i + 1) begin: PE_clear_acc_true_val_gen
      assign PE_clear_acc_true_val[PE_clear_acc_true_val_i+1] = PE_clear_acc_reg[PE_clear_acc_true_val_i];
    end
  endgenerate

  // only for waveform
  genvar gv_weight;
  generate
    for (gv_weight = 0; gv_weight < BM_NUM; gv_weight = gv_weight + 1) begin : weight_in
      wire signed [BW_WET-1:0] PE_wet_in_tmp;
      assign PE_wet_in_tmp = PE_wet_in[gv_weight];
    end
  endgenerate

  genvar gv_input;
  generate
    for (gv_input = 0; gv_input < ACCU_NUM; gv_input = gv_input + 1) begin : act_in
      wire signed [BW_ACT-1:0] PE_act_in_tmp;
      assign PE_act_in_tmp = PE_act_in_reg[gv_input];
    end
  endgenerate

  genvar gv_output1, gv_output2;
  generate
    for (gv_output1 = 0; gv_output1 < BM_NUM; gv_output1 = gv_output1 + 1) begin : act_output1
      for (gv_output2 = 0; gv_output2 < BN_NUM; gv_output2 = gv_output2 + 1) begin : act_output2
        wire signed [BW_ACCU-1:0] PE_result_out_tmp;
        assign PE_result_out_tmp = PE_result_out[gv_output1][gv_output2];
      end
    end
  endgenerate

  genvar gv_output_reg1, gv_output_reg2;
  generate
    for (gv_output_reg1 = 0; gv_output_reg1 < BM_NUM; gv_output_reg1 = gv_output_reg1 + 1) begin : act_output_reg1
      for (gv_output_reg2 = 0; gv_output_reg2 < BN_NUM; gv_output_reg2 = gv_output_reg2 + 1) begin : act_output_reg2
        wire signed [BW_ACCU-1:0] PE_result_out_tmp_reg;
        assign PE_result_out_tmp_reg = PE_result_out_reg[gv_output_reg1][gv_output_reg2];
      end
    end
  endgenerate

  genvar gv_output_accumulate1, gv_output_accumulate2;
  generate
    for (gv_output_accumulate1 = 0; gv_output_accumulate1 < BM_NUM; gv_output_accumulate1 = gv_output_accumulate1 + 1) begin : act_output_accumulate1
      for (gv_output_accumulate2 = 0; gv_output_accumulate2 < BN_NUM; gv_output_accumulate2 = gv_output_accumulate2 + 1) begin : act_output_accumulate2
        wire signed [BW_ACCU-1:0] PE_result_out_tmp_accumulate;
        assign PE_result_out_tmp_accumulate = PE_result_out_reg_accumulate[gv_output_accumulate1][gv_output_accumulate2];
      end
    end
  endgenerate

  genvar gv_weight_partial_sel;
  generate
    for (gv_weight_partial_sel = 0; gv_weight_partial_sel < BM_NUM+1; gv_weight_partial_sel = gv_weight_partial_sel + 1) begin : weight_partial_sel
      wire PE_weight_partial_sel_tmp;
      assign PE_weight_partial_sel_tmp = PE_weight_partial_sel_true_val[gv_weight_partial_sel];
    end
  endgenerate

  genvar gv_weight_partial_sel_reg;
  generate 
    for (gv_weight_partial_sel_reg = 0; gv_weight_partial_sel_reg < BM_NUM; gv_weight_partial_sel_reg = gv_weight_partial_sel_reg + 1) begin : weight_partial_sel_reg
      wire PE_weight_partial_sel_reg_tmp;
      assign PE_weight_partial_sel_reg_tmp = PE_weight_partial_sel_reg[gv_weight_partial_sel_reg];
    end
  endgenerate

  genvar gv_counter;
  generate 
    for (gv_counter = 0; gv_counter < BM_NUM; gv_counter = gv_counter + 1) begin : counter_tmp
      wire [COUNTER_MAX_BITWIDTH-1:0] counter_tmp;
      assign counter_tmp = counter[gv_counter];
    end
  endgenerate
  
  genvar gv_result_out_part_temp;
  generate 
    for (gv_result_out_part_temp = 0; gv_result_out_part_temp < BM_NUM; gv_result_out_part_temp = gv_result_out_part_temp + 1) begin : result_out_part_temp
      wire signed [BW_ACCU-1:0] PE_result_out_part_temp_tmp;
      assign PE_result_out_part_temp_tmp = PE_result_out_part_temp[gv_result_out_part_temp];
    end
  endgenerate

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        PE_weight_partial_sel_reg[i] <= 'b1;
      end
    end
    else begin
      PE_weight_partial_sel_reg[0] <= PE_weight_partial_sel;
      for (integer i = 0; i < BM_NUM - 1; i = i + 1) begin
        PE_weight_partial_sel_reg[i+1] <= PE_weight_partial_sel_reg[i]; // shift
      end
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      for (integer i = 0; i < BM_NUM - 1; i = i + 1) begin
        PE_clear_acc_reg[i] <= 'b0;
      end
    end
    else begin
      PE_clear_acc_reg[0] <= PE_clear_acc;
      for (integer i = 0; i < BM_NUM - 2; i = i + 1) begin
        PE_clear_acc_reg[i+1] <= PE_clear_acc_reg[i]; // shift
      end
    end
  end

  // buffer all the activations
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      for (integer i = 0; i < ACCU_NUM; i = i + 1) begin
        PE_act_in_reg[i] <= 'b0;
      end
    end
    else begin
      for (integer i = 0; i < ACCU_NUM; i = i + 1) begin
        PE_act_in_reg[i] <= PE_act_in[i];
      end
    end
  end

  // buffer all the weights
  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= 'b0;
      end
    end
    else begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        PE_wet_in_reg[i] <= PE_wet_in[i];
      end
    end
  end

  // systolic array
  genvar systolic_i, systolic_j;
  generate
    for (systolic_i = 0; systolic_i < ACCU_NUM; systolic_i = systolic_i + 1) begin : systolic_outer
      for (systolic_j = 0; systolic_j < BM_NUM; systolic_j = systolic_j + 1) begin : systolic_inner
        if (systolic_i == 0) begin
          SystolicArrayPEv2 #(
              .BW_ACT(BW_ACT),
              .BW_WET(BW_WET),
              .BW_ACCU(BW_ACCU),
              .TYPE(0)
            ) u_SystolicArrayPEv2 (
              .clk(clk),
              .reset_n(reset_n),
              .PE_mac_enable(PE_mac_enable),
              .PE_clear_weight(1'b0),
              .PE_weight_partial_sel(PE_weight_partial_sel_true_val[systolic_j]),
              .PE_act_in(PE_internal_wire_temp_act[systolic_i][systolic_j]),
              .PE_act_out(PE_internal_wire_temp_act[systolic_i][systolic_j+1]),
              .PE_above_in(PE_internal_wire_temp_accu[systolic_j][systolic_i]),
              .PE_below_out(PE_internal_wire_temp_accu[systolic_j][systolic_i+1])
            );
        end
        else begin
          SystolicArrayPEv2 #(
              .BW_ACT(BW_ACT),
              .BW_WET(BW_WET),
              .BW_ACCU(BW_ACCU),
              .TYPE(1)
            ) u_SystolicArrayPEv2 (
              .clk(clk),
              .reset_n(reset_n),
              .PE_mac_enable(PE_mac_enable),
              .PE_clear_weight(1'b0),
              .PE_weight_partial_sel(PE_weight_partial_sel_true_val[systolic_j]),
              .PE_act_in(PE_internal_wire_temp_act[systolic_i][systolic_j]),
              .PE_act_out(PE_internal_wire_temp_act[systolic_i][systolic_j+1]),
              .PE_above_in(PE_internal_wire_temp_accu[systolic_j][systolic_i]),
              .PE_below_out(PE_internal_wire_temp_accu[systolic_j][systolic_i+1])
            );          
        end
      end
    end
  endgenerate

  // assign the signals
  genvar assign_act;
  generate
    for (assign_act = 0; assign_act < ACCU_NUM; assign_act = assign_act + 1) begin : gen_assign_act
      assign PE_internal_wire_temp_act[assign_act][0] = PE_act_in_reg[assign_act];
    end
  endgenerate

  genvar assign_weight;
  generate 
    for (assign_weight = 0; assign_weight < BM_NUM; assign_weight = assign_weight + 1) begin : gen_assign_weight
      assign PE_internal_wire_temp_accu[assign_weight][0] = PE_wet_in_reg[assign_weight];
    end
  endgenerate

  genvar assign_output;
  generate
    for (assign_output = 0; assign_output < BM_NUM; assign_output = assign_output + 1) begin : gen_assign_output
      assign PE_result_out_part_temp[assign_output] = PE_internal_wire_temp_accu[assign_output][ACCU_NUM];
    end
  endgenerate

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        counter[i] <= 0;
      end
    end
    else begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        if ((PE_weight_partial_sel_true_val[i+1] == 1'b1 && PE_weight_partial_sel_true_val[i] == 1'b0) || PE_clear_acc_true_val[i] == 1'b1) begin
          counter[i] <= 0;
        end
        else begin
          counter[i] <= counter[i] + 1;
        end
      end
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        for (integer j = 0; j < BN_NUM; j = j + 1) begin
          PE_result_out_reg[i][j] <= 'b0;
        end
      end
    end
    else begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        if (counter[i] >= ACCU_NUM && counter[i] < ACCU_NUM + BN_NUM) begin
          for (integer move_i = 0; move_i < BN_NUM - 1; move_i++) begin
            PE_result_out_reg[i][move_i] <= PE_result_out_reg[i][move_i + 1];
          end
          PE_result_out_reg[i][BN_NUM - 1] <= PE_result_out_part_temp[i];
        end
      end
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        for (integer j = 0; j < BN_NUM; j = j + 1) begin
          PE_result_out_reg_accumulate[i][j] <= 'b0;
        end
      end
    end
    else begin
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        if (PE_clear_acc_true_val[i]) begin
          for (integer j = 0; j < BN_NUM; j = j + 1) begin
            PE_result_out_reg_accumulate[i][j] <= 'b0;
          end
        end
      end
      
      for (integer i = 0; i < BM_NUM; i = i + 1) begin
        if (counter[i] == BN_NUM + ACCU_NUM) begin
          for (integer j = 0; j < BN_NUM; j = j + 1) begin
            PE_result_out_reg_accumulate[i][j] <= PE_result_out_reg[i][j] + PE_result_out_reg_accumulate[i][j];
          end
        end
      end
    end
  end

  genvar shift_i, shift_j;
  generate
    for (shift_i = 0; shift_i < BM_NUM; shift_i = shift_i + 1) begin : shift_result_i
      for (shift_j = 0; shift_j < BN_NUM; shift_j = shift_j + 1) begin : shift_result_j
        wire signed [BW_ACCU-1:0] PE_result_shift_temp;
        assign PE_result_shift_temp = PE_result_out_reg_accumulate[shift_i][shift_j] >>> PE_res_shift_num;
        always @(posedge clk or negedge reset_n) begin
          if (~reset_n) begin
            PE_result_out[shift_i][shift_j] <= 'b0;
          end
          else if (PE_result_shift_temp > 127) begin
            PE_result_out[shift_i][shift_j] <= 127;
          end
          else if (PE_result_shift_temp < -128) begin
            PE_result_out[shift_i][shift_j] <= -128;
          end
          else begin
            PE_result_out[shift_i][shift_j] <= PE_result_shift_temp;
          end
        end
      end
    end
  endgenerate

endmodule