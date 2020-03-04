
`include "hglobal.v"

`default_nettype	none

`define NS_SHOW_ERROR 0

`define NS_NUM_TEST 9

`define NS_T9_SRC_SECTION  ((ASZ + DSZ)-1):DSZ
`define NS_T9_DST_SECTION  (ASZ-1):0
`define NS_T9_DAT_SECTION  (DSZ-1):0


module test_9_top 
#(parameter PSZ=`NS_PACKET_SIZE, ASZ=`NS_ADDRESS_SIZE, DSZ=`NS_DATA_SIZE, RSZ=`NS_REDUN_SIZE)
(
	input  i_clk,      // Main Clock (25 MHz)
	input  i_Switch_1, 
	input  i_Switch_2, 
	
	output o_Segment1_A,
	output o_Segment1_B,
	output o_Segment1_C,
	output o_Segment1_D,
	output o_Segment1_E,
	output o_Segment1_F,
	output o_Segment1_G,
	
	output o_Segment2_A,
	output o_Segment2_B,
	output o_Segment2_C,
	output o_Segment2_D,
	output o_Segment2_E,
	output o_Segment2_F,
	output o_Segment2_G,
	output o_LED_1,
	output o_LED_2,
	output o_LED_3,
	output o_LED_4
	);

	wire w_Switch_1;
	reg  r_Switch_1 = `NS_OFF;
	
	localparam redun_sz = (RSZ-1);
	localparam disp_sz = ((redun_sz > 3)?(redun_sz):3);

	reg [`NS_FULL_MSG_SZ-1:0] disp_1_num = `NS_NUM_TEST;
	reg [disp_sz:0] disp_2_num = `NS_NUM_TEST;
	
	reg r_LED_1 = `NS_OFF;
	reg r_LED_2 = `NS_OFF;
	reg r_LED_3 = `NS_OFF;
	reg r_LED_4 = `NS_OFF;
  
	wire w_Segment1_A;
	wire w_Segment1_B;
	wire w_Segment1_C;
	wire w_Segment1_D;
	wire w_Segment1_E;
	wire w_Segment1_F;
	wire w_Segment1_G;
	
	wire w_Segment2_A;
	wire w_Segment2_B;
	wire w_Segment2_C;
	wire w_Segment2_D;
	wire w_Segment2_E;
	wire w_Segment2_F;
	wire w_Segment2_G;

	// Instantiate Debounce Filter
	debounce sw1_inst(
		.i_Clk(i_clk),
		.i_Switch(i_Switch_1),
		.o_Switch(w_Switch_1)
	);
	
	
	wire [ASZ-1:0] ro0_src;
	wire [ASZ-1:0] ro0_dst;
	wire [DSZ-1:0] ro0_dat;
	
	if(! `NS_SHOW_ERROR) begin
		wire [RSZ-1:0] ro0_red;
	end
	
	assign ro0_src = disp_1_num[`NS_T9_SRC_SECTION];
	assign ro0_dst = disp_1_num[`NS_T9_DST_SECTION];
	assign ro0_dat = disp_1_num[`NS_T9_DAT_SECTION];

	if(! `NS_SHOW_ERROR) begin
		calc_redun #(.ASZ(ASZ), .DSZ(DSZ), .RSZ(RSZ)) 
			r1 (ro0_src, ro0_dst, ro0_dat, ro0_red);
	end
	
	// Purpose: When Switch is pressed, update display i_data and o_data
	always @(posedge i_clk)
	begin
		r_Switch_1 <= w_Switch_1;
		
		if((w_Switch_1 == `NS_ON) && (r_Switch_1 == `NS_OFF))
		begin
			disp_1_num <= disp_1_num + 1;
			
			if(! `NS_SHOW_ERROR) begin
				disp_2_num[RSZ-1:0] <= ro0_red;
			end else begin
				disp_2_num[RSZ-1:0] <= 0;
			end
		end		
	end

	bin_to_disp disp_1(
	.i_Clk(i_clk),
	.i_Binary_Num(disp_1_num[3:0]),
	.o_Segment_A(w_Segment1_A),
	.o_Segment_B(w_Segment1_B),
	.o_Segment_C(w_Segment1_C),
	.o_Segment_D(w_Segment1_D),
	.o_Segment_E(w_Segment1_E),
	.o_Segment_F(w_Segment1_F),
	.o_Segment_G(w_Segment1_G)
	);
	
	// Instantiate Binary to 7-Segment Converter
	bin_to_disp disp2(
	.i_Clk(i_clk),
	.i_Binary_Num(disp_2_num[3:0]),
	.o_Segment_A(w_Segment2_A),
	.o_Segment_B(w_Segment2_B),
	.o_Segment_C(w_Segment2_C),
	.o_Segment_D(w_Segment2_D),
	.o_Segment_E(w_Segment2_E),
	.o_Segment_F(w_Segment2_F),
	.o_Segment_G(w_Segment2_G)
	);

	assign o_Segment1_A = ~w_Segment1_A;
	assign o_Segment1_B = ~w_Segment1_B;
	assign o_Segment1_C = ~w_Segment1_C;
	assign o_Segment1_D = ~w_Segment1_D;
	assign o_Segment1_E = ~w_Segment1_E;
	assign o_Segment1_F = ~w_Segment1_F;
	assign o_Segment1_G = ~w_Segment1_G;
	
	assign o_Segment2_A = ~w_Segment2_A;
	assign o_Segment2_B = ~w_Segment2_B;
	assign o_Segment2_C = ~w_Segment2_C;
	assign o_Segment2_D = ~w_Segment2_D;
	assign o_Segment2_E = ~w_Segment2_E;
	assign o_Segment2_F = ~w_Segment2_F;
	assign o_Segment2_G = ~w_Segment2_G;

	assign o_LED_1 = r_LED_1;
	assign o_LED_2 = r_LED_2;
	assign o_LED_3 = r_LED_3;
	assign o_LED_4 = r_LED_4;

endmodule
