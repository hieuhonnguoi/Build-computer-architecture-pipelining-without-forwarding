module ctrl_unit
#(
    parameter WIDTH = 32
)
(
       //input 
		 input logic [WIDTH-1:0] instruction,
		 //output 
		 output logic jmp_sel,  
		 output logic br_unsigned, //1 if the two operands are unsigned
		 output logic rd_wren, // 1 if the instruction writes data into Regfile
		 output logic mem_wren, //1 if the instruction writes data into LSU
		 output logic op_a_sel, //select operand A source: 0 if rs1, 1 if PC
		 output logic op_b_sel, //select operand B source: 0 if rs2, 1 if imm
		 output logic [1:0] wb_sel // select data to write into Reggile: 0 if alu_data, 1 if ld_data, and 2 or 3 if pc_4
		 );
		 //format_type list, 5-upper bit of opcode
		/* 
		 parameter R_type = 5'b01100;
		 parameter I_type = 5'b00100;
		 parameter S_type = 5'b01000;
		 parameter B_type = 5'b11000;
		 parameter L_U_type = 5'b01101;
		 parameter A_U_type = 5'b00101;
		 parameter J_type = 5'b11011;
		 parameter JALR = 5'b11001; */
		 //
		 logic [6:0] control;
	    assign {br_unsigned,rd_wren, mem_wren,op_a_sel,op_b_sel,wb_sel} = control;
		 
		 always_comb begin
		 case({instruction[6:2]}) 
		 5'b01100: control = 7'b0_1_0_0_0_01; //R_type 
		 5'b00100: control = 7'b0_1_0_0_1_01; //I_type
		 5'b00000: control = 7'b0_1_0_0_1_00; //Load_type
		 5'b01000: control = 7'b0_0_1_0_1_10; //S_type
		 5'b11000: if(instruction[13]) control = 7'b1_0_0_1_1_10;
		           else control = 7'b0_0_0_1_1_10;
		 5'b11011: control = 7'b0_1_0_1_1_10; //JAL
		 5'b11001: control = 7'b0_1_0_0_1_10; //JALR
		 5'b01101: control = 7'b0_1_0_0_1_01; //LUI
		 5'b00101: control = 7'b0_1_0_1_1_01; //AUIPC 
		 default : control = 7'b0_0_0_0_0_00;
		 endcase 
		 end
		 assign jmp_sel = ((instruction[6:2] == 5'b11011) | (instruction[6:2] == 5'b11001)) ? 1'b1 : 1'b0;
endmodule: ctrl_unit 
		 
		 
		 
		 
		 