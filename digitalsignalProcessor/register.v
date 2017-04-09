module register (d, clk, reset, Q);
	input [15:0] d;
	input clk, reset;
	
	output reg [15:0] Q;
	
	always @ (posedge clk or negedge reset) begin
		if (!reset)
			Q <= 16'b0;
		else
			Q <= d;
		end
endmodule