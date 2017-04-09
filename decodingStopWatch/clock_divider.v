
module clock_divider (Clock, Reset, Pulse_ms);
	input Clock, Reset;
	output reg Pulse_ms;
	reg [15:0] count;
	
	localparam countCompare = 25000;
	
	always @(posedge Clock or posedge Reset)
		if (Reset == 1'b1)
		begin
			count <= 15'b0;
			Pulse_ms <= 1'b0;
		end
		else if (count == countCompare -1)
		begin	
			count <= 15'b0;
			Pulse_ms <= ~Pulse_ms;
		end
		else
		begin	
			count <= count +1;
			Pulse_ms <= Pulse_ms;
		end
		
endmodule