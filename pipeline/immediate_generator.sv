module immediate_generator(
                     //input 
                     input logic [31:7] inst,
                     input logic [2:0] imm_sel,
							//output
                     output logic [31:0] immediate);
              
       always_comb begin
           case(imm_sel)
			    //I_type msb_extend
             3'b000: immediate = {{20{inst[31]}},inst[31:20]}; 
				 //S_type msb-extend
             3'b001: immediate = {{20{inst[31]}},inst[31:25],inst[11:7]}; 
				 //B_type msb_extend
             3'b010: immediate = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8], 1'b0};
				 //J_type
				 3'b011: immediate = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
				 //U_type
				 3'b100: immediate = {inst[31:12], {12{1'b0}}}; 
				 //I_type zero_extend
				 3'b101: immediate = {{20{1'b0}},inst[31:20]}; 
				 //B_type zero_extend
				 default:immediate = {{19{1'b0}},inst[31],inst[7],inst[30:25],inst[11:8], 1'b0}; 
           endcase 
        end
endmodule : immediate_generator   