// src/top.v
`timescale 1ns/1ps

module top(clk , rst , out);
    input rst , clk;
    output [3:0] out;

    counter cnt(clk , rst , out);
endmodule
