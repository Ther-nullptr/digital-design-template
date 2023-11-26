`timescale 1ns/1ps
`define CLK_PERIOD          10 //100MHz

module tb_pe_array; // test bench

    parameter MAC_NUM    =   10;  // number of multiply-accumulation units
    parameter BW_ACT     =   8;  // bit length of activation
    parameter BW_WET     =   8;  // bit length of weight
    parameter BW_ACCU    =   32;    // bit length of accu result

    parameter IA_H = 100;
    parameter IA_W = 150;
    parameter Weight_H = 150;
    parameter Weight_W = 16;
    parameter OA_H = 100;
    parameter OA_W = 16;

    reg clk;
    reg reset_n;
    reg PE_mac_enable;
    reg PE_clear_acc;

    reg signed  [BW_ACT-1:0]    PE_act_in                       [MAC_NUM-1:0];                   // input activation
    reg signed  [BW_WET-1:0]    PE_wet_in;                                                       // input weight
    reg         [7:0]           PE_res_shift_num;
    wire signed [BW_ACT-1:0]    PE_result_out                   [MAC_NUM-1:0];                   // output result

    reg signed  [BW_ACT-1:0]    Input_activation_main_memory    [IA_H-1:0][IA_W-1:0];            // main memory (DRAM)
    reg signed  [BW_ACT-1:0]    Weight_main_memory              [Weight_H-1:0][Weight_W-1:0];
    reg signed  [BW_ACT-1:0]    Output_activation_main_memory   [OA_H-1:0][OA_W-1:0];
    reg signed  [BW_ACT-1:0]    reference_output                [OA_H-1:0][OA_W-1:0];

    //! only for waveform
    genvar gv_i;
    for (gv_i = 0; gv_i < MAC_NUM; gv_i = gv_i + 1) begin : line
        wire signed [BW_ACT-1:0] PE_result_out_tmp;
        assign PE_result_out_tmp = PE_result_out[gv_i];
    end

    pe_array #(
                 .MAC_NUM(MAC_NUM),
                 .BW_ACT(BW_ACT),
                 .BW_WET(BW_WET),
                 .BW_ACCU(BW_ACCU)
             ) u_pe_array(
                 .clk(clk),
                 .reset_n(reset_n),
                 .PE_mac_enable(PE_mac_enable),
                 .PE_clear_acc(PE_clear_acc),
                 .PE_act_in(PE_act_in),
                 .PE_wet_in(PE_wet_in),
                 .PE_res_shift_num(PE_res_shift_num),
                 .PE_result_out(PE_result_out)
             );

    initial begin
        clk = 0;
        reset_n = 1;
        PE_res_shift_num = 8;
        PE_clear_acc = 0;
        for(integer n=0;n<MAC_NUM;n=n+1) begin
            PE_act_in[n] <= '0;
        end
        PE_wet_in <= '0;
        forever begin
            #(`CLK_PERIOD/2) clk = ~clk; //模拟时钟产生
        end
    end
    integer wrong_num=0; // 记录错误数据
    initial begin
        @(negedge clk);
        reset_n = 0; //经过一个周期，拉低reset信号

        // 加载任务数据（不是相对testbench的路径，而是相对于simv文件的路径）
        $readmemb("../test/input_act_bin.txt", Input_activation_main_memory);
        $readmemb("../test/weight_bin.txt", Weight_main_memory);
        $readmemb("../test/reference_output_bin.txt", reference_output);

        // loop nest
        @(negedge clk);
        reset_n = 1;

        PE_mac_enable = 1;
        for(integer m=0;m<OA_W;m=m+1) begin
            for(integer j=0;j<IA_H/MAC_NUM;j=j+1) begin
                for(integer i=0;i<IA_W;i=i+1) begin
                    @(negedge clk) begin
                         if(i==0) begin
                             PE_clear_acc <= 0; // 确保清零工作准时结束
                         end
                         for(integer n=0;n<MAC_NUM;n=n+1) begin //相当于课件中的spatial for，在一个周期内完成
                             PE_act_in[n] <= Input_activation_main_memory[j*MAC_NUM+n][i];
                         end
                         PE_wet_in <= Weight_main_memory[i][m];
                     end
                 end
                 @(negedge clk) begin
                      PE_clear_acc <= 1;
                  end
                  @(negedge clk) //结果输出会经过两个周期，因此再打一拍延时
                   @(negedge clk) begin
                       for(integer n=0;n<MAC_NUM;n=n+1) begin
                           Output_activation_main_memory[j*MAC_NUM+n][m] <= PE_result_out[n];
                       end
                   end
               end
           end
           //所有数据都算完后，与reference output进行比对，检验正确与否
           for(integer k=0;k<OA_H;k=k+1) begin
               for(integer p=0;p<OA_W;p=p+1) begin
                   if(Output_activation_main_memory[k][p]!=reference_output[k][p]) begin
                       $display("wrong at (%d %d), output %d, reference %d", k, p, Output_activation_main_memory[k][p], reference_output[k][p]);
                       wrong_num = wrong_num + 1;
                   end
               end
           end
           $display("wrong num: %d",wrong_num);
        @(negedge clk)
         $finish(0);//仿真结束，自动退出 !!! (important for getting the running time)
    end

    initial begin // 加载任务数据（不是相对testbench的路径，而是相对于simv文件的路径）
        $dumpfile("../vcd/tb_pe_array.vcd");
        $dumpvars(0, tb_pe_array);
    end

endmodule
