// src/counter.v
`timescale 1ns/1ps

module counter(clk , rst , out);
    input rst , clk;
    output reg [3:0] out;

    always @(negedge rst or posedge clk)
    begin
    if ( !rst )
        out <= 0;
    else
        out <= out + 1;
    end
endmodule
