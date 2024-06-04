module E_M_register(
  //input 
  input logic clk_i,
  input logic rst_ni,
  
  input logic reg_write_EX,
  input logic mem_write_EX,
  
  input logic [1:0] wb_sel_EX,
  input logic [4:0]  rd_EX,
  input logic [31:0] pc_EX,
  input logic [31:0] alu_result_EX,
  input logic [31:0] rs2_data_EX,
  input logic [2:0]  funct3_EX,
  //output 
  output logic reg_write_M,
  output logic mem_write_M,
  
  output logic [1:0] wb_sel_M,
  output logic [4:0]  rd_M,
  output logic [31:0] pc_M,
  output logic [31:0] alu_result_M,
  output logic [31:0] rs2_data_M,
  output logic [2:0]  funct3_M
);
  always@(posedge clk_i)
  begin 
  if(!rst_ni )
  begin
     reg_write_M   <= 1'b0;
     mem_write_M   <= 1'b0;
     wb_sel_M      <= 2'b0;
     rd_M          <= 5'b0;
     pc_M          <= 32'b0;
     alu_result_M  <= 32'b0;
     rs2_data_M    <= 32'b0;
	  funct3_M      <= 3'b0;
  end
  else
  begin
     reg_write_M   <= reg_write_EX;
     mem_write_M   <= mem_write_EX;
     wb_sel_M      <= wb_sel_EX;
     rd_M          <= rd_EX;
     pc_M          <= pc_EX;
     alu_result_M  <= alu_result_EX;
     rs2_data_M    <= rs2_data_EX;
	  funct3_M      <= funct3_EX;
  end
  end
endmodule: E_M_register
  