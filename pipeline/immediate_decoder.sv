module immediate_decoder(
       //input
		 input logic [5:0] instruction_i,
		 input logic [2:0] u_flag_i, // [14:12] instruction detect unsigned arithmetic 
		 //output 
		 output logic [2:0]imm_sel_o
		 );
		 //decide format type
		 parameter R_type = 5'b01100;
		 parameter I_type = 5'b00100;
		 parameter L_type = 5'b00000;
		 parameter S_type = 5'b01000;
		 parameter B_type = 5'b11000;
		 parameter L_U_type = 5'b01101;
		 parameter A_U_type = 5'b00101;
		 parameter J_type = 5'b11011;
		 
		 //decide immediate type
		 parameter I_imm = 6'b010000;
		 parameter S_imm = 6'b001000;
		 parameter B_imm = 6'b000100;
		 parameter U_imm = 6'b000010;
		 parameter J_imm = 6'b000001;
		 parameter L_imm = 6'b010001;
		 logic [5:0] type_control;
		 //detect format_type
		 always_comb
		 begin
		 case(instruction_i[4:0])
		 R_type: type_control =  6'b100000;
		 I_type: type_control =  6'b010000;
		 S_type: type_control =  6'b001000;
		 B_type: type_control =  6'b000100;
		 L_U_type: type_control =  6'b000010;
		 A_U_type: type_control =  6'b000010;
		 J_type: type_control =  6'b000001;
		 default: type_control = 6'b010001; //L_type
		 endcase
		 end
		 
		 //decide imm_sel_o
		 always_comb begin
		 case(type_control)
		 I_imm: if(u_flag_i == 3'b011)begin 
		           if(instruction_i[5] == 1) imm_sel_o = 3'b000;
					  else imm_sel_o = 3'b101 ;
				  end 
				  else imm_sel_o = 3'b000;
		 L_imm: imm_sel_o = (u_flag_i == 3'b101 || u_flag_i == 3'b100 ) ? 3'b101 : 3'b000;
		 S_imm: imm_sel_o = 3'b001;
		 B_imm: imm_sel_o = (u_flag_i[2:1] != 2'b11) ? 3'b010 : 3'b111;
		 U_imm: imm_sel_o = 3'b100;
		 J_imm: imm_sel_o = 3'b011;
		 default: imm_sel_o = 3'b000;
		 endcase
		 end
endmodule: immediate_decoder
		 