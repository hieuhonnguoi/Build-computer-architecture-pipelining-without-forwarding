module F_D_register(
  //input 
  input logic clk_i,
  input logic rst_ni,
  input logic clear_i, //for flush 
  input logic enable_ni, // for stall 
  
  input logic [31:0]instr_IF,
  input logic [31:0]pc_IF,
  //output 
  output logic [31:0]instr_ID,
  output logic [31:0]pc_ID
 );
   always_ff @(posedge clk_i) begin
        if (clear_i || (!rst_ni)) begin
            instr_ID   <= 32'b0;
            pc_ID      <= 32'b0;
        end
        else if (!enable_ni) begin
           instr_ID   <= instr_IF;
	        pc_ID      <= pc_IF;
        end       
    end

endmodule : F_D_register