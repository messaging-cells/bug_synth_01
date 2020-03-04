# verilog_defaults -add -I./cell_src_snk/
yosys -import
read_verilog bin_to_disp.v; 
read_verilog debouncer.v; 
read_verilog tree_nand.v; 
read_verilog calc_redun.v; 
read_verilog test_bug_top.v;
synth_ice40 -blif ../$::env(BUILD_DIR)/test_bug_top.blif;
synth_ice40 -json ../$::env(BUILD_DIR)/test_bug_top.json;
