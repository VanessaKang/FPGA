module hex_counter(Clock, Reset, Enable, Stp, Q);
	input Clock, Reset, Enable, Stp;
	output [31:0] Q;
	reg [31:0] Q;
	
	always @(posedge Clock or posedge Reset or posedge Stp)
		if (Enable)
		begin
			if (Reset == 1)
				Q <= 0;
			else if (Stp == 1)
				Q <= Q;
			else
				Q <= Q + 1;
		end
	
endmodule