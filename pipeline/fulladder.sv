
module fulladder 
#(
    parameter WIDTH = 32
)
(
	// input
    input logic [WIDTH-1:0] a_i ,
    input logic [WIDTH-1:0] b_i ,
    input logic cin_i ,
   // output
	 output logic cout_o ,
	 output logic [WIDTH-1:0]s_o
);
    always_comb
	 begin
	 {cout_o,s_o} = a_i + b_i + cin_i;
	 end
endmodule: fulladder