###################################################################

# Created by write_sdc on Thu Nov 23 18:12:48 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max ss_0p9v_125c -max_library                        \
scadv10_cln65gp_rvt_ss_0p9v_125c\
                         -min ff_1p1v_m40c -min_library                        \
scadv10_cln65gp_rvt_ff_1p1v_m40c
set_wire_load_mode top
set_wire_load_model -name tsmc65_wl10 -library scadv10_cln65gp_rvt_ss_0p9v_125c
set_max_fanout 70 [current_design]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports clk]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports reset_n]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports PE_mac_enable]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports PE_clear_acc]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[79]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[78]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[77]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[76]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[75]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[74]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[73]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[72]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[71]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[70]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[69]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[68]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[67]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[66]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[65]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[64]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[63]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[62]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[61]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[60]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[59]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[58]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[57]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[56]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[55]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[54]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[53]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[52]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[51]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[50]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[49]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[48]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[47]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[46]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[45]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[44]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[43]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[42]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[41]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[40]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[39]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[38]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[37]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[36]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[35]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[34]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[33]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[32]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[31]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[30]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[29]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[28]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[27]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[26]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[25]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[24]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[23]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[22]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[21]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[20]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[19]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[18]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[17]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[16]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[15]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[14]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[13]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[12]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[11]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[10]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[9]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[8]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[7]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[6]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[5]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[4]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[3]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[2]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[1]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_act_in[0]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[7]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[6]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[5]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[4]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[3]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[2]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[1]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports {PE_wet_in[0]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[7]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[6]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[5]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[4]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[3]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[2]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[1]}]
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports                      \
{PE_res_shift_num[0]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[79]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[78]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[77]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[76]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[75]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[74]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[73]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[72]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[71]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[70]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[69]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[68]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[67]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[66]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[65]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[64]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[63]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[62]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[61]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[60]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[59]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[58]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[57]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[56]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[55]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[54]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[53]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[52]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[51]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[50]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[49]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[48]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[47]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[46]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[45]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[44]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[43]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[42]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[41]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[40]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[39]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[38]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[37]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[36]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[35]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[34]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[33]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[32]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[31]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[30]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[29]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[28]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[27]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[26]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[25]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[24]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[23]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[22]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[21]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[20]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[19]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[18]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[17]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[16]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[15]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[14]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[13]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[12]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[11]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[10]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[9]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[8]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[7]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[6]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[5]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[4]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[3]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[2]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[1]}]
set_load -pin_load 0.5 [get_ports {PE_result_out[0]}]
set_ideal_network [get_ports reset_n]
create_clock [get_ports clk]  -name sys_clk  -period 10  -waveform {0 5}
set_clock_latency -source 0  [get_clocks sys_clk]
set_clock_uncertainty 0.1  [get_clocks sys_clk]
set_clock_transition -min -fall 0.1 [get_clocks sys_clk]
set_clock_transition -min -rise 0.1 [get_clocks sys_clk]
set_clock_transition -max -fall 0.1 [get_clocks sys_clk]
set_clock_transition -max -rise 0.1 [get_clocks sys_clk]
set_input_delay -clock sys_clk  0.2  [get_ports clk]
set_input_delay -clock sys_clk  0.2  [get_ports reset_n]
set_input_delay -clock sys_clk  0.2  [get_ports PE_mac_enable]
set_input_delay -clock sys_clk  0.2  [get_ports PE_clear_acc]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[79]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[78]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[77]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[76]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[75]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[74]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[73]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[72]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[71]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[70]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[69]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[68]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[67]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[66]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[65]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[64]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[63]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[62]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[61]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[60]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[59]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[58]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[57]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[56]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[55]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[54]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[53]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[52]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[51]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[50]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[49]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[48]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[47]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[46]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[45]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[44]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[43]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[42]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[41]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[40]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[39]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[38]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[37]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[36]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[35]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[34]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[33]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[32]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[31]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[30]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[29]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[28]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[27]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[26]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[25]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[24]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[23]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[22]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[21]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[20]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[19]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[18]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[17]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[16]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[15]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[14]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[13]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[12]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[11]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[10]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[9]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[8]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[7]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[6]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[5]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[4]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[3]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[2]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[1]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_act_in[0]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[7]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[6]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[5]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[4]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[3]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[2]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[1]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_wet_in[0]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[7]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[6]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[5]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[4]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[3]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[2]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[1]}]
set_input_delay -clock sys_clk  0.2  [get_ports {PE_res_shift_num[0]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[79]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[78]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[77]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[76]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[75]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[74]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[73]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[72]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[71]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[70]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[69]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[68]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[67]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[66]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[65]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[64]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[63]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[62]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[61]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[60]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[59]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[58]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[57]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[56]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[55]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[54]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[53]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[52]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[51]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[50]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[49]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[48]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[47]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[46]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[45]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[44]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[43]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[42]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[41]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[40]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[39]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[38]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[37]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[36]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[35]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[34]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[33]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[32]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[31]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[30]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[29]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[28]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[27]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[26]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[25]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[24]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[23]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[22]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[21]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[20]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[19]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[18]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[17]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[16]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[15]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[14]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[13]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[12]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[11]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[10]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[9]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[8]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[7]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[6]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[5]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[4]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[3]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[2]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[1]}]
set_output_delay -clock sys_clk  0.2  [get_ports {PE_result_out[0]}]
