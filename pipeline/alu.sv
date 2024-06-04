module alu
#(
    parameter WIDTH = 32
)
(
       //input 
		 input logic [WIDTH-1: 0] operand_a,
		 input logic [WIDTH-1: 0] operand_b,
		 input logic [3:0] alu_control,
		 //output 
		 output logic [WIDTH-1: 0] alu_data
		 );
		 logic [WIDTH-1: 0] two_com_operand_b; // two's complement of operand b
		 logic [WIDTH-1 : 0 ] sub;
		 logic carry_flag;  //detect error in unsigned arithmetic 
		 logic compare_flag; //detect error in signed arithmetic
		 
		 
		 logic [31:0] sll; 
	    logic [31:0] srl;
	    logic [31:0] sra;
		 sll sll_block(
		     .a_i(operand_a),
			  .b_i(operand_b[4:0]),
			  .c_i(sll)
			  );
		 srl srl_block(
		     .a_i(operand_a),
			  .b_i(operand_b[4:0]),
			  .c_i(srl)
			  );
		 sra sra_block(
		     .a_i(operand_a),
			  .b_i(operand_b[4:0]),
			  .c_i(sra)
			  );
	
		 //detect carry_flag and overlow_flag
		 always_comb begin
		     two_com_operand_b =~operand_b +1'b1;
		     {carry_flag, sub} = operand_a + two_com_operand_b;
		     compare_flag = (operand_a[31] != operand_b[31]) ? operand_a[31] : !carry_flag;
		 //same sign bit -> carry = 1 <=> a > b , carry = 0 <=> a<b
		 //different sign bit -> pos num  > neg num
		 end 
		 
		 always_comb begin
		 case(alu_control)
		 4'b0000: alu_data = operand_a + operand_b;  //addition
		 4'b0001: alu_data = sub; //subtraction
		 4'b0010: alu_data = {31'd0, compare_flag}; //set less than - signed arithmetic
		 4'b0011: if(operand_b == 32'd0) alu_data = 0;
		          else alu_data = {31'd0, !carry_flag };  //set less than - unsigned arithmetic  
		 4'b0100: alu_data = operand_a ^ operand_b;   //exor
		 4'b0101: alu_data = operand_a | operand_b;  //or
		 4'b0110: alu_data = operand_a & operand_b; //and
		 4'b0111: alu_data = sll; //shift left logical 
		 4'b1000: alu_data = srl; //shift right logical
		 4'b1001: alu_data = sra; //shift right arithmetic
		 default: alu_data = operand_b; // for LUI instruction 
		 endcase
		 end 
endmodule : alu