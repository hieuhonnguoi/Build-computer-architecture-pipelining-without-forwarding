module brcomp
#(
    parameter WIDTH = 32
)
(
       //input 
		 input logic [WIDTH-1:0] rs1_data,
		 input logic [WIDTH-1:0] rs2_data,
		 input logic br_unsigned, //1 if two operands are unsigned
		 //output
		 output logic br_less,
		 output logic br_equal
		 );
		 logic [WIDTH-1:0] two_com_rs2; // two's complement of rs2_data
		 logic [WIDTH-1:0] sub;
		 logic carry_flag, compare_flag; 
		 
		 //calculate carry_flag and compare_flag
		 always_comb begin
		 two_com_rs2 = ~rs2_data+1'b1; //two's complement of rs2_data
		 {carry_flag, sub }= rs1_data + two_com_rs2;
		 compare_flag = (rs1_data[31] != rs2_data[31]) ? rs1_data[31] : !carry_flag;
		 end
		 
		 always_comb begin 
		 if(br_unsigned) // unsigned arithmetic 
		 begin 
		 br_equal = (sub == 32'd0) ? 1'b1 : 1'b0; 
		 if(rs2_data == 32'd0) br_less = carry_flag;
		 else br_less = (!carry_flag) ? 1'b1 : 1'b0;
		 end
		 else //signed arithmetic 
		 begin
		 br_equal = (sub == 32'd0) ? 1'b1 : 1'b0; 
		 if(rs2_data == 0) br_less = rs1_data[WIDTH-1];
		 else br_less = compare_flag;
		 end 
		 end
endmodule: brcomp
		 
		 