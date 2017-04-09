module immediate_extractor (input [7:0] instruction, input [1:0] select, output reg [7:0] immediate);

	always@(*)
		begin 
			case(select)
				2'b00: immediate = {5'b00000,instruction[4:2]}; //ADDI and SUBI MOVA 
				2'b01: immediate = {4'b0000,instruction[3:0]}; //SR0 and SRH0
				2'b10: immediate = {{3{instruction[4]}},instruction[4:0]}; //BR and BRZ
				2'b11: immediate = 8'h00; // MOV
			endcase
		end

endmodule
