# bug_synth_01
Seems like non used modules in yosys screw up place and routing in nextpnr.

A simple make will make OK.

To show the error:
	- set NS_SHOW_ERROR to 1 in rtl/test_bug_top.v
	- make again to show the error

Observe that the only thing that setting NS_SHOW_ERROR to 1 is doing is preventing module calc_redun from beeing used.

