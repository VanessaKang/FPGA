module lab2 (input CLOCK_50, input [2:0] KEY, output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	/* fill code */
	
	wire dividedPulse;
	wire hexCounterVal;
	
	wire hex_0, hex_1, hex_2, hex_3, hex_4, hex_5, hex_6, hex_7;
	
	// inverted key inputs for logic high when pressed
	
	KEY[0] = ~KEY[0];
	KEY[1] = ~KEY[1];
	KEY[2] = ~KEY[2];
	
	// Module instantiations
	
	control_ff flipflop(.Clock(CLOCK_50), .ff_in(ff_in), .Set(KEY[1]), .Clear(KEY[2]), .Q(Q)); // need to clarify this module
	
	clock_divider clockDivider(.Clock(CLOCK_50), .Reset(KEY[0]), .Pulse_ms(dividedPulse));
	
	hex_counter counter(.Clock(dividedPulse), .Reset(KEY[0]), .Enable(KEY[1]), .Stp(KEY[2]), .Q(hexCounterVal));
	
	hex_to_bcd_converter hex2BCD(.Clock(dividedPulse), .Reset(KEY[0]), .hex_number(hexCounterVal), .bcd_digit_0(hex_0), .bcd_digit_1(hex_1), 
	.bcd_digit_2(hex_2), .bcd_digit_3(hex_3), .bcd_digit_4(hex_4), .bcd_digit_5(hex_5), .bcd_digit_6(hex_6), .bcd_digit_7(hex_7));
	
	// Instantiated 8 sevent segment LEDs 
	
	seven_seg_decoder hexLED0(.x(hex_0), .hex_LEDS(HEX0));
	seven_seg_decoder hexLED1(.x(hex_1), .hex_LEDS(HEX1));
	seven_seg_decoder hexLED2(.x(hex_2), .hex_LEDS(HEX2));
	seven_seg_decoder hexLED3(.x(hex_3), .hex_LEDS(HEX3));
	seven_seg_decoder hexLED4(.x(hex_4), .hex_LEDS(HEX4));
	seven_seg_decoder hexLED5(.x(hex_5), .hex_LEDS(HEX5));
	seven_seg_decoder hexLED6(.x(hex_6), .hex_LEDS(HEX6));
	seven_seg_decoder hexLED7(.x(hex_7), .hex_LEDS(HEX7));
	
endmodule