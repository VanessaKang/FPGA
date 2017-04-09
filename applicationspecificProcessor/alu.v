module alu (input add_sub, set_low, set_high, input signed[7:0] operanda , operandb, output reg signed[7:0] result);
	
		always @(*)
			begin 
				if (set_low) 
					result = {{operanda[7:4]}, {operandb[3:0]}}; // SR0
				else if(set_high)
					result = {{operandb[3:0]}, {operanda[3:0]}}; // SRH0
				else	
					begin 
						if (add_sub)
							result = operanda - operandb;
						else 
							result = operanda + operandb;
					end
			end
endmodule
