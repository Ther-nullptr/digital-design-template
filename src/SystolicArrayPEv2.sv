//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayPEv2.sv
// Author:  Ther
// Date: 2023.11.29
// Notee: systolic array PE MxN
//////////////////////////////////////////////////////////////////////////


module SystolicArrayPEv1 # (
  parameter BW_ACT              =   8,   // bit length of activation
  parameter BW_WET              =   8,   // bit length of weight
  parameter BW_ACCU             =   32   // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_weight,  
  input  weight_partial_sel, // 0 for mac, 1 for weight
  input  signed [BW_ACT-1:0]   PE_act_in,
  input  signed [BW_ACT-1:0]  PE_act_out,
  input  signed [BW_ACCU-1:0]  PE_above_in,
  output signed [BW_ACCU-1:0]  PE_below_out // when the weight spread out, the bitwidth is cut down
);
  reg signed [BW_WET-1:0]   PE_wet_in_reg;      // weight buffer

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      PE_wet_in_reg <= 'b0;
      PE_act_out <= 'b0;
    end
    else if (PE_clear_weight) begin
      PE_act_out <= 'b0;
      PE_wet_in_reg <= 'b0;
    end
    else if (weight_partial_sel) begin // if in weight update stage, the buffer is updated, otherwise keep the value
      PE_act_out <= PE_act_in;
      PE_wet_in_reg <= PE_above_in[BW_WET-1:0]
    end
  end
  assign PE_below_out = weight_partial_sel ? (PE_mac_enable ? (PE_above_in + PE_act_in * PE_wet_in_reg) : 'b0) : PE_wet_in_reg;

endmodule