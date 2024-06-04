
module pc
#(
    parameter WIDTH = 32
)
(
          //input
          input logic clk_i,
          input logic rst_ni,
			 input logic enable_ni,
			 input logic [WIDTH-1:0] next_pc,
			 //output
			 output logic [WIDTH-1:0] current_pc,
			 output logic [WIDTH-1:0] pc_debug_o);
			 
			 always_ff @(posedge clk_i)
			 begin 
			 if( !rst_ni ) 
			 current_pc <= 32'd0;
			 else if(!enable_ni)
			 current_pc <= next_pc;
			 end
			 assign pc_debug_o = current_pc;
endmodule:pc