module or_2 (
	// input 
    input logic a_i ,
    input logic b_i ,
    
	// output
	output logic result_o
);

    assign result_o = a_i | b_i ;

endmodule : or_2