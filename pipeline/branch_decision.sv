module branch_decision(
  //input
  input logic [4:0] opcodeE_i,
  input logic [2:0] funct3E_i,
  input logic br_less,
  input logic br_equal,
  //output 
  output logic br_sel
);
     assign br_sel =   ((({opcodeE_i,funct3E_i} == 8'b11000000) && br_equal == 1) |
	                     (({opcodeE_i,funct3E_i} == 8'b11000001) && br_equal == 0) |
					  			(({opcodeE_i,funct3E_i} == 8'b11000100) && br_less == 1)  |
								(({opcodeE_i,funct3E_i} == 8'b11000101) && br_less == 0)  |
								(({opcodeE_i,funct3E_i} == 8'b11000110) && br_less == 1)  |
								(({opcodeE_i,funct3E_i} == 8'b11000111) && br_less == 0)) ? 1'b1 : 1'b0;
endmodule: branch_decision