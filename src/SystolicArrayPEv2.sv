//////////////////////////////////////////////////////////////////////////
// Filename: SystolicArrayPEv2.sv
// Author:  Ther
// Date: 2023.11.27
// Notee: systolic array PE
//////////////////////////////////////////////////////////////////////////


module SystolicArrayPEv2 # (
  parameter BW_ACT              =   8,   // bit length of activation
  parameter BW_WET              =   8,   // bit length of weight
  parameter BW_ACCU             =   32   // bit length of accu result
) (
  input  clk,
  input  reset_n,
  input  PE_mac_enable,
  input  PE_clear_weight,  
  input  weight_load_en,
  input  signed [BW_ACT-1:0]   PE_act_in,
  input  signed [BW_WET-1:0]   PE_wet_in,
  input  signed [BW_ACCU-1:0]  PE_above_in,
  output signed [BW_ACCU-1:0]  PE_below_out // when the weight spread out, the bitwidth is cut down
);
  reg signed [BW_WET-1:0]   PE_wet_in_reg;      // weight buffer

  always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin // reset to zero
      PE_wet_in_reg <= 'b0;
    end
    else if (PE_clear_weight) begin
      PE_wet_in_reg <= 'b0;
    end
    else if (weight_load_en) begin
      PE_wet_in_reg <= PE_wet_in;
    end
  end
  assign PE_out = PE_mac_enable ? (PE_accu_in + PE_act_in * PE_wet_in_reg) : 'b0;

endmodule