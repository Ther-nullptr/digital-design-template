# Create user defined variables 
set RST [get_ports rst]
set CLK_PORT [get_ports clk]
set CLK_PERIOD 50	
set CLK_SKEW 0.1
set CLK_DELAY 0.01
set INPUT_DELAY 0.2
set OUTPUT_DELAY 0.2

set MAX_AREA 0

# Reset Cons
remove_driving_cell $RST
set_drive 0 $RST
set_dont_touch_network [get_ports rst]
set_ideal_network [get_ports rst]


# Time Budget 
#set clock
create_clock -period $CLK_PERIOD -name sys_clk $CLK_PORT
set_dont_touch_network sys_clk
set_clock_transition 0.1 sys_clk
set_clock_uncertainty $CLK_SKEW [get_clocks sys_clk]
#set_clock_latency  $CLK_DELAY [get_clocks sys_clk]
set_clock_latency -source  0 [get_clocks sys_clk]


set_input_delay $INPUT_DELAY -clock sys_clk [all_inputs]
set_driving_cell  -lib_cell BUFHX2MA10TR  -pin Y [all_inputs]

set_max_fanout 70 $topcell
set_output_delay $OUTPUT_DELAY -clock sys_clk [all_outputs]
set_load  0.5 [all_outputs]

#  Area Constraint
# set_max_area 0

# Operating Environment 
set_operating_conditions -max "ss_0p9v_125c" -max_library "scadv10_cln65gp_rvt_ss_0p9v_125c" -min "ff_1p1v_m40c" -min_library "scadv10_cln65gp_rvt_ff_1p1v_m40c"

#set wire_model
set auto_wire_load_selection true
set_wire_load_model -name tsmc65_wl10 -library scadv10_cln65gp_rvt_ss_0p9v_125c
set_wire_load_mode top



set_dont_use scadv10_cln65gp_rvt_ss_0p9v_125c/ESDFF*
set_dont_use scadv10_cln65gp_rvt_ss_0p9v_125c/SDFF*
set_dont_use scadv10_cln65gp_rvt_ss_0p9v_125c/EDFF*    

