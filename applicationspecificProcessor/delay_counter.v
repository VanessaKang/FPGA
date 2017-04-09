module delay_counter (input clk, reset_n, start, enable, input [7:0] delay, output done);
parameter BASIC_PERIOD=19'd500000;

// 19 bits to count up to 500,000
// for a 50 Mhz clock, the 1/100 second is 500,000 clock cycle,  that is 19'd500000
 reg [7:0] downcounter;
 reg [19:0] timer;
 
	always@(posedge clk)
		begin 
		
			if(!reset_n)
				begin
					timer <= 20'd0;
					downcounter <=8'h00;
				end
				
			else if (start == 1'b1)
				begin
					timer <=20'd0;
					downcounter <= delay; 
				end
				
			else if (enable == 1'b1)
				begin	
					if (timer<BASIC_PERIOD)
						timer <= timer + 20'd1;
						
					else
						begin 
							downcounter <= downcounter - 8'b1;
							timer <= 20'd0;
						end
						
				end
		end
		
	assign done = (downcounter == 8'b00000000)?1'b1:1'b0;
endmodule
