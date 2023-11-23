# Setup Input and Output files
set topcell top
set src_files [list ./src/top.v ./src/counter.v]
set cons ./scripts/cons.tcl

set output_sdf  ./netlist/top_post.sdf
set output_sdc  ./sdc/top_post.sdc
set output_db   ./db/top_post.ddc
set output_v    ./netlist/top_post.v

set rpt_timing_nw   ./report/rpt_time_nw_top
set rpt_timing_max  ./report/rpt_time_max_top
set rpt_timing_min  ./report/rpt_time_min_top
set rpt_area        ./report/rpt_area_top
set rpt_cell        ./report/rpt_cell_top
set rpt_hierarchy   ./report/rpt_hierarchy_top
set rpt_resources   ./report/rpt_resources_top
set rpt_constraint  ./report/rpt_constraint_top

# Start the Syn process
analyze -f Verilog $src_files 

elaborate $topcell

read_verilog $src_files

current_design $topcell

link

change_names -rule verilog -hier

uniquify -force

source $cons

check_design

#ungroup -all -flatten

compile -map_effort medium -area_effort medium

# Remove unconnected ports
remove_unconnected_ports [get_cells -hier *] > remove_ports.log

# Remove feedthrough
foreach_in_collection each_design [all_designs] {
	current_design $each_design
	set_fix_multiple_port_nets -all -buffer_constants
}

current_design $topcell

# Second pass compile
compile -incr -map medium

set_fix_hold sys_clk
compile -incr -only_design_rule

write_sdf $output_sdf

write_sdc $output_sdc

write -f ddc -hier -o $output_db 

write -f verilog -hier -o $output_v

set_svf cod.svf

report_timing -nworst 10 > $rpt_timing_nw
report_timing -delay max -max_paths 100 > $rpt_timing_max
report_timing -delay min -max_paths 100 > $rpt_timing_min
report_area > $rpt_area
report_cell > $rpt_cell
report_hierarchy > $rpt_hierarchy
report_resources > $rpt_resources
report_constraint > $rpt_constraint
