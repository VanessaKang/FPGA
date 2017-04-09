module dsp_subsystem (input sample_clock,  input reset, input [1:0] selector, input [15:0] input_sample, output reg [15:0] output_sample);

	wire [15:0] output_ECHO;
	wire [15:0] output_FIR;

	echo_machine ECHO(.clock(sample_clock), .reset_n(reset), .input_echo(input_sample), .output_echo(output_ECHO));
	fir_filter FILTER(.clock(sample_clock), .reset_n(reset), .input_fir(input_sample), .output_fir(output_FIR));
	defparam FILTER.taps = 65;
		always @ (posedge sample_clock or negedge reset)
			begin
				case(selector)
					2'b00: output_sample = input_sample;
					2'b01: output_sample = output_ECHO;
					2'b10: output_sample = output_FIR;
				endcase
			end
	
endmodule