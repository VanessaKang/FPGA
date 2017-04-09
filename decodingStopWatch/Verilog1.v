module lab2 (input CLOCK_50, input [2:0] KEY, output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7)
 /* fill your code and instantiate other modules here */
 /*most of the variables used are similar to diagram on lab2*/
 
	wire clk_en;
	wire count;
	
	//diferent wire segments that carry information to the other LEDS
	wire segment_1;
	wire segment_2;
	wire segment_3;
	wire segment_4;
	wire segment_5;
	wire segment_6;
	wire segment_7;
	
	// instantiated Modules from next few questions (q5-q9)
	control_ff control_FF(Clock(CLOCK_50), ff_in(ff_in), Set(KEY[1]), Clear(KEY[0]), Q(q_in));
	
	clock_divider clock_DIVIDER(Clock(CLOCK_50), Reset(KEY{0}]), Pulse_ms(clk_en));
	
	hex_counter hex_COUNTER(Clock(clk_en), Reset(KEY[0]), Enable(KEY[1], Stp(KEY[2]), Q(count));
	
	hex_to_bcd_converter HtoBCD(clk (clk_en), Reset(KEY[0]), hex_number(count), bcd_digit_0(segment_0),
	bcd_digit_1(segment_1),bcd_digit_2(segment_2),bcd_digit_3(segment_3),bcd_digit_4(segment_4), 
	bcd_digit_5(segment_5), bcd_digit_6(segment_6), bcd_digit_7(segment_7));
	
	seven_seg_decoder segment_DECODE0(x(segment_0), hex_LEDs(HEX0));
	seven_seg_decoder segment_DECODE1(x(segment_1), hex_LEDs(HEX1));
	seven_seg_decoder segment_DECODE2(x(segment_2), hex_LEDs(HEX2));
	seven_seg_decoder segment_DECODE3(x(segment_3), hex_LEDs(HEX3));
	seven_seg_decoder segment_DECODE4(x(segment_4), hex_LEDs(HEX4));
	seven_seg_decoder segment_DECODE5(x(segment_5), hex_LEDs(HEX5));
	seven_seg_decoder segment_DECODE6(x(segment_6), hex_LEDs(HEX6));
	seven_seg_decoder segment_DECODE7(x(segment_7), hex_LEDs(HEX7));

	/* the three key inputs need to be inverted to produce a logic high when pressed as explained in the document */

	KEY[0] = ~KEY[0]; //reset
	KEY[1] = ~KEY[1]; //start
	KEY[2] = ~KEY[2]; //stop
	
endmodule