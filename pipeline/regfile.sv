module regfile
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5
)
(   //input 
    input logic clk_i,
    input logic rst_ni, //active low reset
    input logic [ADDR_WIDTH-1:0] rs1_addr,
    input logic [ADDR_WIDTH-1:0] rs2_addr,
    input logic [ADDR_WIDTH-1:0] rd_addr,
    input logic [DATA_WIDTH-1:0] rd_data,
    input logic rd_wren,
    //output 
    output logic [DATA_WIDTH-1:0] rs1_data,
    output logic [DATA_WIDTH-1:0] rs2_data
    
);
    logic [DATA_WIDTH-1:0] register[2**ADDR_WIDTH - 1 : 0];
	 initial begin
	 register[0] <= 0;
	 end
    //write rd_data
    always_ff @(negedge clk_i) begin
            if ((rd_wren == 1'b1) && (rd_addr != 5'b00000) ) 
            begin 
                register[rd_addr] <= rd_data ;
               // $writememh("........");
            end
				
	 end
	
    //read rs1 rs2 data
    always_comb begin
    rs1_data = register[rs1_addr];
    rs2_data = register[rs2_addr];
    end 
    
endmodule : regfile