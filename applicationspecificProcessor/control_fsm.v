module control_fsm (
	input clk, reset_n,
	// Status inputs
	input br, brz, addi, subi, sr0, srh0, clr, mov, mova, movr, movrhs, pause,
	input delay_done,
	input temp_is_positive, temp_is_negative, temp_is_zero,
	input register0_is_zero,
	// Control signal outputs
	output reg write_reg_file,
	output reg result_mux_select,
	output reg [1:0] op1_mux_select, op2_mux_select,
	output reg start_delay_counter, enable_delay_counter,
	output reg commit_branch, increment_pc,
	output reg alu_add_sub, alu_set_low, alu_set_high,
	output reg load_temp_register, increment_temp_register, decrement_temp_register,
	output reg [1:0] select_immediate,
	output reg [1:0] select_write_address
	
);
parameter RESET=5'b00000, FETCH=5'b00001, DECODE=5'b00010,
			BR=5'b00011, BRZ=5'b00100, ADDI=5'b00101, SUBI=5'b00110, SR0=5'b00111,
			SRH0=5'b01000, CLR=5'b01001, MOV=5'b01010, MOVA=5'b01011,
			MOVR=5'b01100, MOVRHS=5'b01101, PAUSE=5'b01110, MOVR_STAGE2=5'b01111,
			MOVR_DELAY=5'b10000, MOVRHS_STAGE2=5'b10001, MOVRHS_DELAY=5'b10010,
			PAUSE_DELAY=5'b10011;

reg [5:0] state;
reg [5:0] next_state_logic; // NOT REALLY A REGISTER!!!

// Next state logic
	always@(posedge clk)
		begin 
			if (!reset_n)
				state<= RESET;
			else	
				state<= next_state_logic; 
		end
//Cases for the States
	always@(*)
		begin 
		//Please Refer to Appendix A to see the next_state_logic
		//The default state would be reset to make sure it enters the first step
			case(state)
				RESET: 
					next_state_logic = FETCH; 
				FETCH: 
					next_state_logic = DECODE;
				DECODE:
					begin
						if (br)
							next_state_logic = BR;
						else if(brz)
							next_state_logic = BRZ;
						else if (addi)
							next_state_logic = ADDI;
						else if(subi)
							next_state_logic = SUBI;
						else if(sr0)
							next_state_logic = SR0;
						else if(srh0)
							next_state_logic = SRH0;
						else if (clr)
							next_state_logic = CLR;
						else if (mov)
							next_state_logic = MOV; 
						else if (mova)
							next_state_logic = MOVA; 
						else if (movr)
							next_state_logic = MOVR;
						else if (movrhs)	
							next_state_logic = MOVRHS;
						else if (pause)
							next_state_logic = PAUSE;
					end
				BR: 
					next_state_logic = FETCH; 
				BRZ: 
					next_state_logic = FETCH;
				ADDI:
					next_state_logic = FETCH;	
				SUBI:
					next_state_logic = FETCH;
				SR0:
					next_state_logic = FETCH;
				SRH0:
					next_state_logic = FETCH;
				CLR: 
					next_state_logic = FETCH;
				MOV: 
					next_state_logic = FETCH;
				MOVA:
					next_state_logic = FETCH;
				MOVR:
					next_state_logic = MOVR_STAGE2;
				MOVRHS:
					next_state_logic = MOVRHS_STAGE2;
				PAUSE:
					next_state_logic = PAUSE_DELAY;
				MOVR_STAGE2:
					if (temp_is_zero)
						next_state_logic = FETCH;
					else 
						next_state_logic = MOVR_DELAY;
				MOVRHS_STAGE2:
					if (temp_is_zero)
						next_state_logic = FETCH;
					else 
						next_state_logic = MOVRHS_DELAY;
				PAUSE_DELAY:
					if (delay_done)
						next_state_logic = FETCH;
					else	
						next_state_logic = PAUSE_DELAY;
				MOVR_DELAY:
					if (delay_done)
						next_state_logic = MOVR_STAGE2;
					else	
						next_state_logic = MOVR_DELAY;
				MOVRHS_DELAY:
					if (delay_done)
						next_state_logic = MOVRHS_STAGE2;
					else
						next_state_logic = MOVRHS_DELAY;
				default: 
					next_state_logic = RESET; // makes sure it starts at the beginning (makes it run continually and enter RESET state)
			endcase
		end
	
// Output logic
	always@(*)
		begin
			// initializing ALL the signal control outputs
			// These were defined in the module at the top of this module (output signals)
			// These signals are defined in Appendix B 
			write_reg_file = 1'b0;
			result_mux_select = 1'b0;
			op1_mux_select = 2'b00;
			op2_mux_select = 2'b00;
			start_delay_counter = 1'b0;
			enable_delay_counter = 1'b0;
			commit_branch = 1'b0;
			increment_pc = 1'b0;
			alu_add_sub = 1'b0;
			alu_set_low = 1'b0;
			alu_set_high = 1'b0;
			load_temp_register = 1'b0;
			increment_temp_register = 1'b0;
			decrement_temp_register = 1'b0;
			select_immediate = 2'b00;
			select_write_address = 2'b00;	
			
			// Each equation for each state is defined from Appendix A (they are in comments before defining)
			// I looked at Appendix B and my specifications to see how to execute each control signal
			case(state)
				
				BR: 
				//-----------------------
				// PC = PC + sext(imm3)
				//-----------------------
					begin
//						write_reg_file = 1'b0;
//						result_mux_select = 1'b1; // this is defaulted
						op1_mux_select = 2'b01; // Chooses PC on OP
						op2_mux_select = 2'b01; // Chooses Immediate on OP
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
						commit_branch = 1'b1; // loading PC to another place
//						increment_pc = 1'b0;
						alu_add_sub = 1'b0; // this is adding it to PC
//						alu_set_low = 1'b0;
//						alu_set_high = 1'b0;						
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
						select_immediate = 2'b10; //Chooses immediate for BR
//						select_write_address = 2'b00;
						//--------------------
					end
				BRZ: 
				//-------------------------------------
				// if (RF[0] == 0)
				//		PC ← PC + sext(imm5)
				//	else
				//		PC ← PC + 1
				//-------------------------------------
				//The Signals for BRZ copies some from BR
					begin 
						if (register0_is_zero)
							begin 
								op1_mux_select = 2'b01;
								op2_mux_select = 2'b01;
								commit_branch = 1'b1;
								alu_add_sub = 1'b0;
								select_immediate = 2'b10;
							end
						else	
							increment_pc = 1'b1; //increment PC goes to next instruction
					end
				ADDI:
				//--------------------------------------
				//RF [reg] ← RF [reg] + imm3
				//PC ← PC + 1
				//--------------------------------------
					begin 
						write_reg_file = 1'b1; // writing to RegisterFile 
						result_mux_select = 1'b0; // Output from ALU goes to REGFILE
						op1_mux_select = 2'b01; //Register  on OP
						op2_mux_select = 2'b01; //Immediate on OP
						alu_add_sub = 1'b0; // Addition 
						select_write_address = 2'b01; //reg_field0 goes to selected0 then to Register on OP
						select_immediate = 2'b00; // Immediate that deals with ADDI
						increment_pc = 1'b1; //increment PC goes to next instruction
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						commit_branch = 1'b0;
//						alu_set_low = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
					end
				SUBI:
				//-----------------------------------------------
				//RF [reg] ← RF [reg] - imm3
				//PC ← PC + 1
				//-----------------------------------------------
					begin
						write_reg_file = 1'b1; // make sure we can write to RF
						result_mux_select = 1'b0; // Output from ALU goes to REGFILE
						op1_mux_select = 2'b01; //Register  on OP
						op2_mux_select = 2'b01; //Immediate on OP
						alu_add_sub = 1'b1; //Subtraction
						select_write_address = 2'b01; //reg_field0 goes to selected0 then to Register on OP
						select_immediate = 2'b00;// Immediate that deals with ADDI
						increment_pc = 1'b1;//increment PC goes to next instruction
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						commit_branch = 1'b0;
//						alu_set_low = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
					end 
				SR0:
				//-----------------------------------------------
				//RF [0] ← {RF [0]7:4,imm4}
				//PC ← PC + 1 
				//-----------------------------------------------
					begin 
						write_reg_file = 1'b1;// make sure we can write to RF 
						result_mux_select = 1'b0;// Output from ALU goes to REGFILE
						op1_mux_select = 2'b11; //Select R0 on Op
						op2_mux_select = 2'b01; //Select Immediate
						alu_set_low = 1'b1; // This is alu implementation for SR0 [7,4],[3,0] 
						select_write_address = 2'b00; // select R0
						select_immediate = 2'b01; // Immediate went to OP2 for Concatenation
						increment_pc = 1'b1; // Next instruction
//						//------------------------
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						alu_add_sub = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
					end
				SRH0:
				//-------------------------------------------
				//RF [0] ← {imm4,RF [0]3:0}
				//PC ← PC + 1 
				//-------------------------------------------
					begin 
						select_immediate = 2'b01; // Immediate went to OP2 for Concatenation
						op1_mux_select = 2'b11; //Select R0 on Op
						op2_mux_select = 2'b01; //Select Immediate
						alu_set_high = 1'b1; // This is alu implementation for SR0 [3,0],[3,0]
						result_mux_select = 1'b0;// Output from ALU goes to REGFILE
						write_reg_file = 1'b1;// make sure we can write to RF 
						select_write_address = 2'b00; // select R0
						increment_pc = 1'b1; // Next instruction
//						//------------------------
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						alu_add_sub = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
					end	
				CLR: 
				//------------------------------------------------
				//RF [reg] ← 0
				//PC ← PC + 1
				//------------------------------------------------
					begin
						result_mux_select = 1'b1; // This requires no ALU output so data into REG is zero
						write_reg_file = 1'b1; // Writing to a register
						select_write_address = 2'b01; //write to R1
						increment_pc = 1'b1; // Next Instruction
						//------------------------------
//						op1_mux_select = 2'b00;
//						op2_mux_select = 2'b00;
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						alu_add_sub = 1'b0;
//						alu_set_low = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
//						select_immediate = 2'b00;					
					end
				MOV: 
				//------------------------------------------------
				//RF [regd] ← RF [regs]
				//PC ← PC + 1
				//------------------------------------------------
					begin
						select_immediate = 2'b11; // Immediate that deals with MOV
						op1_mux_select = 2'b01; // Register into OP
						op2_mux_select = 2'b01; // Immediate into OP
						alu_add_sub = 1'b0; // Addition
						result_mux_select = 1'b0; //ALU output into data of REGFILE
						write_reg_file = 1'b1; //You can write to a register
						select_write_address = 2'b10; //REGFIELD1 => R2 = Controls Position of Stepper
						increment_pc = 1'b1; // Next Instruction
						//---------------------
//						start_delay_counter = 1'b0;
//						enable_delay_counter = 1'b0;
//						commit_branch = 1'b0;
//						alu_set_low = 1'b0;
//						alu_set_high = 1'b0;
//						load_temp_register = 1'b0;
//						increment_temp_register = 1'b0;
//						decrement_temp_register = 1'b0;
					end
				MOVA:
					select_immediate = 2'b00;
				MOVR:
				//---------------------------------------------------------
				//Load Register to store value
				//---------------------------------------------------------
					load_temp_register = 1'b1; 
				MOVRHS:
				//---------------------------------------------------------
				//Load Register to store value 
				//---------------------------------------------------------
					load_temp_register = 1'b1; 
				PAUSE:
				//---------------------------------------------------------
				//Delay_counter ← RF [3]
				//Start the delay counter
				//---------------------------------------------------------
					start_delay_counter = 1'b1; // starts delay counter
				MOVR_STAGE2:
				//---------------------------------------------------------
				//if TEMP == 0
				//		PC ← PC +1
				//else 
				//	if TEMP > 0
				//		TEMP ← TEMP – 1
				//		RF[2] ← RF[2] + 2
				// else
				//		TEMP ← TEMP + 1
				//		RF[2] ← RF[2] – 2
				//	Delay_counter ← RF [3]
				//	Start the delay counter
				//---------------------------------------------------------
					if (temp_is_zero)
							increment_pc = 1'b1;
					else begin
						if(temp_is_positive) begin
							decrement_temp_register = 1'b1; //Decrements temp
							op1_mux_select = 2'b10; //R2 on Op
							op2_mux_select = 2'b11;	//2 on OP (to move full step)
							alu_add_sub = 1'b0; //Addition
							result_mux_select = 1'b0; //ALU Result goes to data of REGFILE
							select_write_address = 2'b11; // Selects 2 as write address to R2
							write_reg_file = 1'b1; // Enables you to write
						end else begin
							increment_temp_register = 1'b1; // Increment Temp
							op1_mux_select = 2'b10; //R2 on OP	
							op2_mux_select = 2'b11; //2 on OP (move full step
							alu_add_sub = 1'b1; //Substraction
							result_mux_select = 1'b0; //ALU result goes to REGFILE
							select_write_address = 2'b11; //Selects 2 as write address to R2
							write_reg_file = 1'b1; //Enables you to write
						end
						start_delay_counter = 1'b1;
					end
				MOVRHS_STAGE2:
				//-----------------------------------------------------------
				//if TEMP == 0
				//		PC ← PC +1
				//	else
				//		if TEMP > 0
				//			 TEMP ← TEMP – 1
				//			 RF[2] ← RF[2] + 1
				//		else
				//			 TEMP ← TEMP + 1
				//			 RF[2] ← RF[2] – 1
				//	Delay_counter ← RF [3]
				// Start the delay counter
				//-----------------------------------------------------------
					begin
						if (temp_is_zero)
							increment_pc = 1'b1;
						else 
							begin
								if(temp_is_positive)
									begin
										decrement_temp_register = 1'b1;
										op1_mux_select = 2'b10;
										op2_mux_select = 2'b10; // Selects 1 on OP
										alu_add_sub = 1'b0;
										result_mux_select = 1'b0;
										select_write_address = 2'b11;
										write_reg_file = 1'b1;
									end 
								else 
									begin
										increment_temp_register = 1'b1;
										op1_mux_select = 2'b10;
										op2_mux_select = 2'b10; //Selects 1 on OP
										alu_add_sub = 1'b1;
										result_mux_select = 1'b0;
										select_write_address = 2'b11;
										write_reg_file = 1'b1;
									end
							end
						start_delay_counter = 1'b1;
					end
							
				PAUSE_DELAY:
				//-----------------------------------------------
				//Run the delay counter
				// if delay expired
				//		PC ← PC + 1
				//-----------------------------------------------
					begin
						enable_delay_counter = 1'b1; // run delay counter
						if (delay_done) // once delay is expired, 
							increment_pc = 1'b1; // Next Instruction
						end
						
						default: result_mux_select = 1'b1;
				MOVR_DELAY:
				//--------------
				//Run the delay counter
				//--------------
					enable_delay_counter = 1'b1;
				MOVRHS_DELAY:
				//--------------
				//Run the delay counter
				//--------------
					enable_delay_counter = 1'b1;
			endcase
	end		
endmodule
