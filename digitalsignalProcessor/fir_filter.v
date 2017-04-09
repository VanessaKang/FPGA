//`timescale 1ns / 1ps
module fir_filter(clock, reset_n, input_fir, output_fir);
	input clock, reset_n;
	input [15:0] input_fir;
	output [15:0] output_fir;
	
	parameter taps = 30; //you didnt have taps set as a value lol
	reg signed [15:0] coeffs[taps-1:0];
	reg signed[15:0] tmp_sum[taps-1:0];
	reg signed [15:0] final_sum;
	reg [15:0] mem_storage[taps-1:0];
	wire signed [31:0] mult_out[taps-1:0];
	
	integer i;
	integer x;
	// Set up coeffsicients
	always @(*) begin
		coeffs[0]=         0;
		coeffs[1]=       756;
		coeffs[2]=        -0;
		coeffs[3]=     -1010;
		coeffs[4]=         0;
		coeffs[5]=      1540;
		coeffs[6]=        -0;
		coeffs[7]=     -2112;
		coeffs[8]=        -0;
		coeffs[9]=      2662;
		coeffs[10]=         0;
		coeffs[11]=     -3119;
		coeffs[12]=         0;
		coeffs[13]=      3422;
		coeffs[14]=        -0;
		coeffs[15]=     29240;
		coeffs[16]=        -0;
		coeffs[17]=      3422;
		coeffs[18]=         0;
		coeffs[19]=     -3119;
		coeffs[20]=         0;
		coeffs[21]=      2662;
		coeffs[22]=        -0;
		coeffs[23]=     -2112;
		coeffs[24]=        -0;
		coeffs[25]=      1540;
		coeffs[26]=         0;
		coeffs[27]=     -1010;
		coeffs[28]=        -0;
		coeffs[29]=       756;
		coeffs[30]=         0;
	end
	

	generate
	genvar l;
	for (l = 0; l < taps; l = l + 1)
		begin: mult
			multiplier mult_l(.dataa(coeffs[l]), .datab(mem_storage[l]), .result(mult_out[l]));
		end
	endgenerate	
	
	
	// Core logic
	always @ (posedge clock or posedge reset_n) begin
		if (reset_n) begin
			output_fir = 0;
			for (i = 0; i < taps; i = i + 1) begin
				mem_storage[i] = 0;
			end
		end
		
		else begin
			for (i = taps - 1; i > 0; i = i - 1) begin
				mem_storage[i] = mem_storage[i-1];
			end
			mem_storage[0] = input_fir;
		end
		
		for (i = 0; i < taps; i = i + 1) begin
			 tmp_sum[i] = {mult_out[i][31], mult_out[i][29:15]};
		end
		
		final_sum = 0;
		for (i = 0; i < taps; i = i + 1) begin
			final_sum = final_sum + tmp_sum[i];
		end
		
		output_fir = final_sum;
	end
	
endmodule