// src/tb.v
`timescale 1ns/1ps

module tb;
    reg rst, clk;
    wire [3:0] dout;

    top uut(clk, rst, dout);

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        // $sdf_annotate("../netlist/top_post.sdf", tb.uut);
        rst = 1;
        #15 rst = 0;
        #25 rst = 1;
        #2000 $stop;
    end
        
    initial begin
        $dumpfile("../vcd/tb.vcd");
        $dumpvars(0);
        // $fsdbDumpfile("../netlist/wave.fsdb");//指定输出的fsdb波形文件
        // $fsdbDumpvars(0);
    end

endmodule
