module M_WB_register(
   //input
	input logic clk_i,
	input logic rst_ni,

	input logic reg_write_M,
	input logic [31:0] pc_M,
	input logic [1:0] wb_sel_M,
	input logic [4:0] rd_M,
	input logic [31:0] alu_out_M,
	input logic [31:0] data_load_M,
	//output 
	output logic reg_write_WB,
	output logic [31:0] pc_WB,
	output logic [1:0] wb_sel_WB,
	output logic [4:0] rd_WB,
	output logic [31:0] alu_out_WB,
	output logic [31:0] data_load_WB
);
  always @ (posedge clk_i)
  begin
  if(!rst_ni)
  begin
     reg_write_WB   <= 1'b0;
     wb_sel_WB      <= 2'b0;
	  pc_WB          <= 32'b0;
	  rd_WB          <= 5'b0;
	  alu_out_WB     <= 32'b0;
	  data_load_WB   <= 32'b0;
  end
  else begin
     reg_write_WB   <= reg_write_M;
     wb_sel_WB      <= wb_sel_M;
	  pc_WB          <= pc_M;
	  rd_WB          <= rd_M;
	  alu_out_WB     <= alu_out_M;
	  data_load_WB   <= data_load_M;
  end
  end
endmodule :M_WB_register