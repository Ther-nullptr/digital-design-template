//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayPEv1.sv
// Author:  Ther
// Date: 2023.11.27
// Notee: systolic array PE
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module SystolicArrayPEv2 # (
  parameter BW_ACT              =   8,   // bit length of activation
  parameter BW_WET              =   8,   // bit length of weight
  parameter BW_ACCU             =   32,  // bit length of accu result
  parameter TYPE                =   0
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_weight,  
  input  PE_weight_partial_sel, // 0 for mac, 1 for weight
  input  signed [BW_ACT-1:0] PE_act_in,
  input  signed [BW_ACCU-1:0] PE_above_in,
  output reg signed [BW_ACT-1:0]  PE_act_out,
  output reg signed [BW_ACCU-1:0] PE_below_out // when the weight spread out, the bitwidth is cut down
);
  reg signed [BW_WET-1:0] PE_wet_in_reg;      // weight buffer
  reg PE_weight_partial_sel_out;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      PE_weight_partial_sel_out <= 'b0;
    end
    else begin
      PE_weight_partial_sel_out <= PE_weight_partial_sel;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin // reset to zero
      PE_wet_in_reg <= 'b0;
    end
    else if (PE_clear_weight) begin
      PE_wet_in_reg <= 'b0;
    end
    else if (PE_weight_partial_sel_out) begin // if in weight update stage, the buffer is updated, otherwise keep the value
      PE_wet_in_reg <= PE_above_in[BW_WET-1:0];
    end
    else begin
      PE_wet_in_reg <= PE_wet_in_reg;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin // reset to zero
      PE_act_out <= 'b0;
    end
    else if (PE_mac_enable) begin
      PE_act_out <= PE_act_in;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin // reset to zero
      PE_below_out <= 'b0;
    end
    else if (PE_weight_partial_sel_out) begin // if in weight update stage, the buffer is updated, otherwise keep the value
      PE_below_out <= PE_above_in[BW_WET-1:0];
    end
    else if (PE_mac_enable) begin // if in mac stage, the buffer is updated, otherwise keep the value`
      if (TYPE == 0) begin
        PE_below_out <= PE_act_in * PE_wet_in_reg;
      end
      else begin
        PE_below_out <= PE_above_in + PE_act_in * PE_wet_in_reg;
      end
    end
    else begin
      PE_below_out <= 'b0;
    end
  end
  
endmodule