module mux3_1
#(
    parameter WIDTH = 32
)
(
       //input
		 input logic [WIDTH-1:0]a_i,
		 input logic [WIDTH-1:0]b_i,
		 input logic [WIDTH-1:0]c_i,
		 input logic [1:0] sel,
		 //output 
		 output logic [WIDTH-1:0]result_o);
		 
		 always_comb begin
		 case(sel)
		 2'b00: result_o = a_i;
		 2'b01: result_o = b_i;
		 default result_o = c_i;
		 endcase
		 end
endmodule: mux3_1