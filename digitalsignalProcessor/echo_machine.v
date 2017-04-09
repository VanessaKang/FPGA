module echo_machine(clock, reset_n, input_echo, output_echo);
	input clock, reset_n;
	input [15:0] input_echo;
	output reg [15:0] output_echo;

	wire [15:0] delayed_sig;
	reg [15:0] delayed_input = 16'b0;
	reg [15:0] attenuated_delay;
	
	/* Instantiating the delay for the output signal fed back into the system
		Created 32*32 = 1024 registers of width 16 bits for excessive delay */
	shiftregister delay(.clock(clock), .shiftin(delayed_input), .shiftout(delayed_sig));
	
	always @(posedge clock or negedge reset_n) begin
		if (!reset_n) begin
			// Need to reset shift register values
			/*
			for (i = 0; i < 255; i = i + 1) begin
				delay(.shiftin(16'b0));
			end
			*/		
			output_echo <= 0;
			delayed_input <= 0;
		end
		
		attenuated_delay <= {{2{delayed_sig[15]}}, delayed_sig[15:2]};
		output_echo <= attenuated_delay + input_echo;
		delayed_input <= output_echo;	
	
	end	
endmodule
		