###################################################################

# Created by write_sdc on Thu Nov 23 14:24:10 2023

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
set_driving_cell -lib_cell BUFHX2MA10TR -pin Y [get_ports rst]
set_load -pin_load 0.5 [get_ports {out[3]}]
set_load -pin_load 0.5 [get_ports {out[2]}]
set_load -pin_load 0.5 [get_ports {out[1]}]
set_load -pin_load 0.5 [get_ports {out[0]}]
set_ideal_network [get_ports rst]
create_clock [get_ports clk]  -name sys_clk  -period 50  -waveform {0 25}
set_clock_latency -source 0  [get_clocks sys_clk]
set_clock_uncertainty 0.1  [get_clocks sys_clk]
set_clock_transition -min -fall 0.1 [get_clocks sys_clk]
set_clock_transition -min -rise 0.1 [get_clocks sys_clk]
set_clock_transition -max -fall 0.1 [get_clocks sys_clk]
set_clock_transition -max -rise 0.1 [get_clocks sys_clk]
set_input_delay -clock sys_clk  0.2  [get_ports clk]
set_input_delay -clock sys_clk  0.2  [get_ports rst]
set_output_delay -clock sys_clk  0.2  [get_ports {out[3]}]
set_output_delay -clock sys_clk  0.2  [get_ports {out[2]}]
set_output_delay -clock sys_clk  0.2  [get_ports {out[1]}]
set_output_delay -clock sys_clk  0.2  [get_ports {out[0]}]
