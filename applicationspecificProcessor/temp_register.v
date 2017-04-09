module temp_register (input clk, reset_n, load, increment, decrement, input [7:0] data, output negative, positive, zero);
	
    reg signed[7:0] register = 8'b00000000;

    always @(posedge clk) 
	 begin
        if (!reset_n) 
            register <= 8'b00000000;
				
        else if (load)
            register <= data;

        else if (increment)
            register <= register + 8'b00000001;

        else if (decrement)
            register <= register - 8'b00000001;
				
    end

    assign zero = (register == 8'b00000000);
    assign positive = ((register[7] == 1'b0) && (register != 8'b00000000));
    assign negative = (register[7] == 1);
	 
endmodule		

