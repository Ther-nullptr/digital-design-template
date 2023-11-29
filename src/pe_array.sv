`timescale 1ns/1ps
module pe_array #(
        parameter MAC_NUM    =   10,  // number of multiply-accumulation units
        parameter BW_ACT     =   8,  // bit length of activation
        parameter BW_WET     =   8,  // bit length of weight
        parameter BW_ACCU    =   32    // bit length of accu result
    )(
        input        clk,
        input        reset_n,
        // // control signal
        input        PE_mac_enable,      // high active
        input        PE_clear_acc,
        // data signal
        input   signed     [BW_ACT-1:0]    PE_act_in [MAC_NUM-1:0] ,         // input activation
        input   signed     [BW_WET-1:0]    PE_wet_in,         // input weight
        input              [7:0]           PE_res_shift_num,
        output  reg signed [BW_ACT-1:0]    PE_result_out [MAC_NUM-1:0]     // output result
    );

    reg signed [BW_ACT-1:0]    PE_act_in_reg [MAC_NUM-1:0] ;      // input buffer
    reg signed [BW_WET-1:0]    PE_wet_in_reg;      // weight buffer
    reg signed [BW_ACCU-1:0]   PE_result_out_reg [MAC_NUM-1:0];
    reg PE_clear_acc_reg; //数据信号因需要存入buffer而延后了1 cycle，该控制信号也延后1 cycle

    genvar gv_input;
    generate
        for (gv_input = 0; gv_input < MAC_NUM; gv_input = gv_input + 1) begin : act_in
            wire signed [BW_ACT-1:0] PE_act_in_tmp;
            assign PE_act_in_tmp = PE_act_in_reg[gv_input];
        end
    endgenerate

    genvar gv_output;
    generate
        for (gv_output = 0; gv_output < MAC_NUM; gv_output = gv_output + 1) begin : act_output
            wire signed [BW_ACT-1:0] PE_result_out_tmp;
            assign PE_result_out_tmp = PE_result_out_reg[gv_output];
        end
    endgenerate

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            PE_clear_acc_reg <= 'b0;
        end
        else begin
            PE_clear_acc_reg <= PE_clear_acc;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin // 复位归零
            PE_wet_in_reg <= 'b0;
        end
        else begin
            PE_wet_in_reg <= PE_wet_in;
        end
    end

    genvar gv_i;
    generate
        for (gv_i = 0; gv_i < MAC_NUM; gv_i = gv_i + 1) begin : line

            wire signed [BW_ACCU-1:0] PE_result_shift_temp;
            always @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin // 复位归零
                    PE_act_in_reg[gv_i] <= 'b0;
                end
                else begin
                    PE_act_in_reg[gv_i] <= PE_act_in[gv_i];
                end
            end

            always @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin // 复位归零
                    PE_result_out_reg[gv_i] <= 'b0;
                end
                else if(~PE_mac_enable) begin //非计算时刻保持不变
                    PE_result_out_reg[gv_i] <= PE_result_out_reg[gv_i];
                end
                else if(PE_clear_acc_reg) begin
                    PE_result_out_reg[gv_i] <= 'b0;
                end
                else begin //乘累加运算
                    PE_result_out_reg[gv_i] <= PE_result_out_reg[gv_i] + PE_wet_in_reg * PE_act_in_reg[gv_i];
                end
            end

            assign PE_result_shift_temp = PE_result_out_reg[gv_i] >>> PE_res_shift_num;
            always @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin
                    PE_result_out[gv_i] <= 'b0;
                end
                else if(PE_result_shift_temp>127) begin
                    PE_result_out[gv_i] <= 127;
                end
                else if(PE_result_shift_temp<-128) begin
                    PE_result_out[gv_i] <= -128;
                end
                else begin
                    PE_result_out[gv_i] <= PE_result_shift_temp[BW_ACT-1:0];  //截取低位
                end
            end
        end
    endgenerate
endmodule
