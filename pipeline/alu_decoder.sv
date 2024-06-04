module alu_decoder(
	// input
    input logic [6:2] instruction,
	 input logic funct7b5,
	 input logic [2:0] funct3,//[14;12] instruction
    
	// output
	output logic [3:0] alu_control
);

    // local declaration
    logic RtypeSub ;
    assign RtypeSub = funct7b5 & instruction[5] ; // TRUE for R-Type subtract
    always_comb begin
        if (instruction == 5'b01100 || instruction == 5'b00100 )begin //R_type and I_type
				     if(RtypeSub == 1 && funct3 == 3'b000) alu_control = 4'b0001; //subtraction
				     else begin
						  case (funct3)
						  3'b000: alu_control = 4'b0000; //addition
						  3'b100: alu_control = 4'b0100; // exor
						  3'b110: alu_control = 4'b0101; // or
						  3'b111: alu_control = 4'b0110; // and
						  3'b001: alu_control = 4'b0111; //shift left logical
						  3'b101: if(funct7b5) alu_control = 4'b1001; //sra
							       else alu_control = 4'b1000; //srl
						  3'b010: alu_control = 4'b0010; //set less than
						  3'b011: alu_control = 4'b0011; //set less than (u)
						  endcase
						  end 
						  end
			else if(instruction == 5'b01101) alu_control = 4'b1111; //for LUI instruction 
			else alu_control = 4'b0000; // addition	  
    end
endmodule