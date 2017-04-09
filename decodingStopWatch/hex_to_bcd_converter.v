module hex_to_bcd_converter (input wire clk, Reset, input wire [31:0] hex_number, output reg [3:0] bcd_digit_0, bcd_digit_1, bcd_digit_2, 
bcd_digit_3, bcd_digit_4, bcd_digit_5, bcd_digit_6, bcd_digit_7);

	integer i;
	always @(posedge clk or posedge Reset)
		begin
		
			for (i = 0; i < 32; i++)
			begin
				
				// Double dabble binary to BCD algorithm
				// Checking to see if any columns are greater than or equal to 5
				if (bcd_digit_7 >= 5)
					bcd_digit_7 += 3;
				if (bcd_digit_6 >= 5)
					bcd_digit_6 += 3;
				if (bcd_digit_5 >= 5)
					bcd_digit_5 += 3;	
				if (bcd_digit_4 >= 5)
					bcd_digit_4 += 3;
				if (bcd_digit_3 >= 5)
					bcd_digit_3 += 3;
				if (bcd_digit_2 >= 5)
					bcd_digit_2 += 3;
				if (bcd_digit_1 >= 5)
					bcd_digit_1 += 3;
				if (bcd_digit_0 >= 5)
					bcd_digit_0 += 3;
					
				bcd_digit_7 = bcd_digit_7 << 1;
				bcd_digit_7[0] = bcd_digit_6[3];
				
				bcd_digit_6 = bcd_digit_6 << 1;
				bcd_digit_6[0] = bcd_digit_5[3];
				
				bcd_digit_5 = bcd_digit_5 << 1;
				bcd_digit_5[0] = bcd_digit_4[3];
				
				bcd_digit_4 = bcd_digit_4 << 1;
				bcd_digit_4[0] = bcd_digit_3[3];
				
				bcd_digit_3 = bcd_digit_3 << 1;
				bcd_digit_3[0] = bcd_digit_2[3];
				
				bcd_digit_2 = bcd_digit_2 << 1;
				bcd_digit_2[0] = bcd_digit_1[3];
				
				bcd_digit_1 = bcd_digit_1 << 1;
				bcd_digit_1[0] = bcd_digit_0[3];
				
				bcd_digit_0 = bcd_digit_0 << 1;
				bcd_digit_0[0] = hex_number[i];
				
			end
		end
endmodule
