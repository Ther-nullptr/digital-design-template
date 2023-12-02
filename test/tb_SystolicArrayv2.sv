`timescale 1ns/1ps
`define CLK_PERIOD          10 //100MHz

module tb_SystolicArrayv2; // test bench

    // NOTE ACCU_NUM should be same or larger than BM_NUM
    // BN_NUM should be same or larger than ACCU_NUM
    parameter BM_NUM     =   4;  // weight buffer bandwidth, as #M
    parameter BN_NUM     =   10;  // number of multiply-accumulation units, as #N
    parameter ACCU_NUM   =   5;  // number of accumulate units, as #K
    parameter BW_ACT     =   8;  // bit length of activation
    parameter BW_WET     =   8;  // bit length of weight
    parameter BW_ACCU    =   32; // bit length of accu result

    parameter IA_H = 100; // N
    parameter IA_W = 150; // K
    parameter Weight_H = 150; // K
    parameter Weight_W = 16; // M
    parameter OA_H = 100; // N
    parameter OA_W = 16; // M

    // parameter IA_H       =   8;
    // parameter IA_W       =   8;
    // parameter Weight_H   =   8;
    // parameter Weight_W   =   8;
    // parameter OA_H       =   8;
    // parameter OA_W       =   8;

    reg clk;
    reg reset_n;
    reg PE_mac_enable;
    reg PE_clear_acc;
    reg PE_weight_partial_sel;

    reg receive_signal;

    reg signed  [BW_ACT-1:0]    PE_act_in [ACCU_NUM-1:0];       // input activation
    reg signed  [BW_WET-1:0]    PE_wet_in [BM_NUM-1:0];         // input weight
    reg         [7:0]           PE_res_shift_num;
    wire signed [BW_ACT-1:0]    PE_result_out [BM_NUM-1:0][BN_NUM-1:0];    // output result

    reg signed  [BW_ACT-1:0]    Input_activation_main_memory [IA_H-1:0][IA_W-1:0]; // main memory (DRAM)
    reg signed  [BW_ACT-1:0]    Weight_main_memory [Weight_H-1:0][Weight_W-1:0];
    reg signed  [BW_ACT-1:0]    Output_activation_main_memory [OA_H-1:0][OA_W-1:0];
    reg signed  [BW_ACT-1:0]    reference_output [OA_H-1:0][OA_W-1:0];

    SystolicArrayv2 #(
                    .BM_NUM(BM_NUM),
                    .BN_NUM(BN_NUM),
                    .ACCU_NUM(ACCU_NUM),
                    .BW_ACT(BW_ACT),
                    .BW_WET(BW_WET),
                    .BW_ACCU(BW_ACCU)
                ) u_SystolicArrayv2 (
                    .clk(clk),
                    .reset_n(reset_n),
                    .PE_mac_enable(PE_mac_enable),
                    .PE_clear_acc(PE_clear_acc),
                    .PE_weight_partial_sel(PE_weight_partial_sel),
                    .PE_act_in(PE_act_in),
                    .PE_wet_in(PE_wet_in),
                    .PE_res_shift_num(PE_res_shift_num),
                    .PE_result_out(PE_result_out)
                );

    initial begin
        clk = 0;
        reset_n = 1;
        PE_res_shift_num = 8;
        PE_clear_acc = 1;
        PE_weight_partial_sel = 1;
        receive_signal = 0;
        for (integer k = 0; k < ACCU_NUM; k = k + 1) begin
            PE_act_in[k] <= '0;
        end
        for (integer k = 0; k < BM_NUM; k = k + 1) begin
            PE_wet_in[k] <= '0;
        end
        forever begin
            #(`CLK_PERIOD/2) clk = ~clk; // 模拟时钟产生
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
        for (integer m = 0; m < OA_W / BM_NUM; m = m + 1) begin
            for (integer j = 0; j < IA_H / BN_NUM; j = j + 1) begin
                for (integer i = 0; i < IA_W / ACCU_NUM; i = i + 1) begin
                    // load weight(purely) to the buffer first
                        for (integer l = 1; l < 1 + ACCU_NUM; l = l + 1) begin
                                // PE_wet_in[l] <= Weight_main_memory[i*ACCU_NUM+ACCU_NUM-1-k][m*BM_NUM+l];
                            if (l == 1) begin
                                @(negedge clk) begin
                                    receive_signal <= 0;
                                    PE_weight_partial_sel <= 1;
                                    PE_clear_acc <= 0;
                                end
                            end
                            @(negedge clk) begin
                            if (l < BM_NUM) begin
                                for (integer idx = 0; idx < l; idx = idx + 1) begin
                                    PE_wet_in[idx] <= Weight_main_memory[i*ACCU_NUM+ACCU_NUM-1+idx-(l-1)][m*BM_NUM+idx];
                                end
                                for (integer idx = l; idx < BM_NUM; idx = idx + 1) begin
                                    PE_wet_in[idx] <= 0;
                                end
                            end
                            else if (l <= ACCU_NUM && l >= BM_NUM) begin
                                for (integer idx = 0; idx < BM_NUM; idx = idx + 1) begin
                                    PE_wet_in[idx] <= Weight_main_memory[i*ACCU_NUM+ACCU_NUM-1+idx-(l-1)][m*BM_NUM+idx];
                                end
                            end
                        end
                    end
                    
                    // then load the activation and rest weight
                    for (integer l = 1; l < BN_NUM + ACCU_NUM; l = l + 1) begin
                        @(negedge clk) begin
                            if (l == 1) begin
                                PE_weight_partial_sel <= 0;
                            end
                            // activation
                            if (l < ACCU_NUM) begin // low utilization
                                for (integer idx = 0; idx < l; idx = idx + 1) begin
                                    PE_act_in[idx] <= Input_activation_main_memory[j*BN_NUM+l-idx-1][i*ACCU_NUM+idx];
                                end
                                for (integer idx = l; idx < ACCU_NUM; idx = idx + 1) begin
                                    PE_act_in[idx] <= 0;
                                end
                            end
                            else if (l <= BN_NUM && l >= ACCU_NUM) begin // high utilization
                                for (integer idx = 0; idx < ACCU_NUM; idx = idx + 1) begin
                                    PE_act_in[idx] <= Input_activation_main_memory[j*BN_NUM+l-idx-1][i*ACCU_NUM+idx];
                                end
                            end 
                            else begin // low utilization
                                for (integer idx = 0; idx < l - BN_NUM; idx = idx + 1) begin
                                    PE_act_in[idx] <= 0;
                                end
                                for (integer idx = l - BN_NUM; idx < ACCU_NUM; idx = idx + 1) begin
                                    PE_act_in[idx] <= Input_activation_main_memory[j*BN_NUM+l-idx-1][i*ACCU_NUM+idx];
                                end
                            end
                            // weight
                            if (l < BM_NUM) begin
                                for (integer idx = 0; idx < l; idx = idx + 1) begin
                                    PE_wet_in[idx] <= 0;
                                end
                                for (integer idx = l; idx < BM_NUM; idx = idx + 1) begin
                                    PE_wet_in[idx] <= Weight_main_memory[i*ACCU_NUM+ACCU_NUM-1+idx-(l+ACCU_NUM-1)][m*BM_NUM+idx];
                                end
                            end
                        end
                    end
                end
                    for (integer clock_i = 0; clock_i < 3 + BM_NUM - 1; clock_i = clock_i + 1) begin
                        @(negedge clk);
                    end
                    @(negedge clk) begin
                        PE_clear_acc <= 1;
                    end
                    @(negedge clk);
                    receive_signal <= 1;
                    for (integer bm = 0; bm < BM_NUM; bm = bm + 1) begin
                        for (integer bn = 0; bn < BN_NUM; bn = bn + 1) begin
                            Output_activation_main_memory[j*BN_NUM+bn][m*BM_NUM+bm] <= PE_result_out[bm][bn];
                        end
                    end
                    @(negedge clk);
                end
            end
            @(negedge clk);
            //所有数据都算完后，与reference output进行比对，检验正确与否
            for(integer k=0;k<OA_H;k=k+1) begin
                for(integer p=0;p<OA_W;p=p+1) begin
                    if (Output_activation_main_memory[k][p]!=reference_output[k][p]) begin
                        $display("(%d %d), output %d, reference %d", k, p, Output_activation_main_memory[k][p], reference_output[k][p]);
                        wrong_num = wrong_num + 1;
                    end 
                end
            end
            $display("wrong num: %d", wrong_num);
        @(negedge clk)
         $finish(0); // 仿真结束，自动退出 !!! (important for getting the running time)
    end

    initial begin // 加载任务数据（不是相对testbench的路径，而是相对于simv文件的路径）
        $dumpfile("../vcd/tb_SystolicArrayv2.vcd");
        $dumpvars(0, tb_SystolicArrayv2);
    end

endmodule
