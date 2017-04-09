module control_ff(Clock, ff_in, Set, Clear, Q);
	input Clock, ff_in, Set, Clear;
	output reg Q;
	/* fill code */
	
	always @(posedge Clock)
	if (ff_in)
		if (~Reset)
		begin
			Q <= 1'b0;
		end
		
		else
		begin
			Q <= Set;
		end	
endmodule