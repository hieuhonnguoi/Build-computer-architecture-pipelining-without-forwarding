module mux2_1
#(
    parameter WIDTH = 32
)
(
       //input
		 input logic [WIDTH-1:0]a_i,
		 input logic [WIDTH-1:0]b_i,
		 input logic sel,
		 //output 
		 output logic [WIDTH-1:0] result_o);
		 always_comb begin
		 case(sel)
		 1'b0: result_o = a_i;
		 1'b1: result_o = b_i;
		 endcase 
		 end
endmodule: mux2_1