module seven_seg_decoder(input [3:0] x, output [6:0] hex_LEDs);

	reg[6:2] top_5_segments;
	
	// Assign statements using gate logic for segments A and B
	assign hex_LEDS[0] = (~x[3] & x[2] & ~x[1] & ~x[0]) | (~x[3] & ~x[2] & ~x[1] & x[0]) | (x[3] & x[2] & ~x[1] & x[0]);
	assign hex_LEDS[1] = (x[3] & ~x[1] & x[0]) | (~x[3] & x[2] & x[1] & ~x[0]);
	
	// Assign HEX_LEDs 2 to 6 using case statement
	assign hex_LEDS[6:2] = top_5_segments[6:2];
	
	always(@x)
		
		// Case statement for segments C, D, E, F, G of 7 segment LED
		case(x)
			begin
				4'b0000: top_5_segments = 5'b00001; // 0
				4'b0001: top_5_segments = 5'b01111; // 1
				4'b0010: top_5_segments = 5'b10010; // 2
				4'b0011: top_5_segments = 5'b00110; // 3
				4'b0100:	top_5_segments = 5'b01100; // 4
				4'b0101: top_5_segments = 5'b00100; // 5
				4'b0110: top_5_segments = 5'b00000; // 6
				4'b0111: top_5_segments = 5'b01111; // 7
				4'b1000: top_5_segments = 5'b00000; // 8
				4'b1001: top_5_segments = 5'b00100; // 9
				4'b1010: top_5_segments = 5'b01000; // R
				4'b1011: top_5_segments = 5'b00001; // O also equal to 0
				4'b1100: top_5_segments = 5'b00000; // B also equal to 8
				4'b1101: top_5_segments = 5'b01111; // I also equal to 1
				4'b1110: top_5_segments = 5'b01001; // N
				4'b1111: top_5_segments = 5'b00000; // G also equal to 6
			end
		endcase
endmodule
