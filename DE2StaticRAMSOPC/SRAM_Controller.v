/*****************************************************************************
 *                                                                           *
 * Module:       SRAM_Controller                                             *
 * Description:                                                              *
 *      This module is used for the sram controller for 3TB4 lab 4           *
 *                                                                           *
 *****************************************************************************/

module SRAM_Controller (
input           clk,
input				 reset_n,
input		[17:0]	address,
input				chipselect,
input		[1:0]	byte_enable,
input				read,
input				write,
input		[15:0]	write_data,

// Bidirectionals
inout wire	[15:0]	SRAM_DQ,

// Outputs
output wire	[15:0]	read_data,
	
output 	[17:0]	SRAM_ADDR,

output				SRAM_CE_N,
output				SRAM_WE_N,
output				SRAM_OE_N,
output				SRAM_UB_N,
output				SRAM_LB_N
);

// Add your code here

	// pass control signals based off of input
	assign SRAM_ADDR = address;
	assign SRAM_CE_N = !(chipselect);
	assign SRAM_WE_N = !(write);
	assign SRAM_OE_N = !(read);
	assign SRAM_UB_N = !(byte_enable[1]);
	assign SRAM_LB_N = !(byte_enable[0]);
	
	assign read_data = read?SRAM_DQ:16'bzzzzzzzzzzzzzzzz;
	assign SRAM_DQ = (write)?write_data:16'bzzzzzzzzzzzzzzzz;
//	always @ (posedge clk)
//		begin
////			if(!reset_n)
////				begin
////					SRAM_DQ <= 16'bzzzzzzzzzzzzzzzz;
////				end  
////			else
////				begin
//					if (!chipselect) 
//					begin
//						SRAM_DQ = 16'bzzzzzzzzzzzzzzzz;
//					end
//		
//					else begin
//						case({read,write})
//							2'b00: SRAM_DQ <= 16'bzzzzzzzzzzzzzzzz;
//							2'b01: SRAM_DQ <= write_data;
//							2'b10: read_data <= SRAM_DQ;
//							default: SRAM_DQ <= 16'bzzzzzzzzzzzzzzzz;
//						endcase	
//					end     
//				end
//		//end			
endmodule