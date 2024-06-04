module imem 
#(
    parameter WIDTH = 32,
	 parameter int unsigned IMEM_W = 13
)
(
  //input
  input logic clk_i,
  input logic rst_ni,
  input  logic [IMEM_W-1:0] addr_i,
  //output
  output logic [WIDTH-1:0]  data_o);

  logic [31:0] i_memory [2**(IMEM_W)-1:0]; // 13 bits -> 8KB 
  
  initial begin
        $readmemh("D:/leson 1/program.txt", i_memory);
  end
  always_comb 
  begin 
    data_o = i_memory[addr_i[IMEM_W-1:2]];
  end

endmodule : imem