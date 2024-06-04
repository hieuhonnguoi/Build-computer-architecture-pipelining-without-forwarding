module D_E_register(
  //input 
  input logic clk_i,
  input logic rst_ni,
  input logic clear_i,
  
  input logic jmp_sel_ID,
  input logic br_unsigned_ID,
  input logic reg_write_ID,
  input logic mem_write_ID,
  input logic srcA_ID,
  input logic srcB_ID,
  input logic [1:0] wb_sel_ID,
  input logic [3:0] alu_control_ID,
  input logic [31:0] immediate_ID,
  
  input logic [31:0] pc_ID,
  input logic [31:0] rs1data_ID,
  input logic [31:0] rs2data_ID,
  input logic [4:0]  rs1_ID,
  input logic [4:0]  rs2_ID,
  input logic [4:0]  rd_ID,
  
  input logic [4:0] opcode_ID,
  input logic [2:0] funct3_ID,

  
  //output 
  output logic jmp_sel_EX,
  output logic br_unsigned_EX,
  output logic reg_write_EX,
  output logic mem_write_EX,
  output logic srcA_EX,
  output logic srcB_EX,
  output logic [1:0] wb_sel_EX,
  output logic [3:0] alu_control_EX,
  output logic [31:0] immediate_EX,
  
  output logic [31:0] pc_EX,
  output logic [31:0] rs1data_EX,
  output logic [31:0] rs2data_EX,
  output logic [4:0]  rs1_EX,
  output logic [4:0]  rs2_EX,
  output logic [4:0]  rd_EX,
  
  output logic [4:0] opcode_EX,
  output logic [2:0] funct3_EX
 );
 always_ff @(posedge clk_i )
    begin 
    if(!rst_ni || clear_i) 
	 begin
	     jmp_sel_EX     <= 1'b0;
        br_unsigned_EX <= 1'b0;
        reg_write_EX   <= 1'b0;
        mem_write_EX   <= 1'b0;
        srcA_EX        <= 1'b0;
        srcB_EX        <= 1'b0;
		  wb_sel_EX      <= 2'b0;
		  alu_control_EX <= 4'b0;
		  immediate_EX   <= 32'b0;
        pc_EX          <= 32'b0;
		  rs1data_EX     <= 32'b0;
		  rs2data_EX     <= 32'b0;
        rs1_EX         <= 5'b0;
	     rs2_EX         <= 5'b0;
	     rd_EX          <= 5'b0;
		  opcode_EX      <= 5'b0;
		  funct3_EX      <= 3'b0;
	
    end 
    else
    begin
	     jmp_sel_EX     <= jmp_sel_ID;
        br_unsigned_EX <= br_unsigned_ID;
        reg_write_EX   <= reg_write_ID;
        mem_write_EX   <= mem_write_ID;
        srcA_EX        <= srcA_ID;
        srcB_EX        <= srcB_ID;
		  wb_sel_EX      <= wb_sel_ID;
		  alu_control_EX <= alu_control_ID;
		  immediate_EX   <= immediate_ID;
        pc_EX          <= pc_ID;
		  rs1data_EX     <= rs1data_ID;
		  rs2data_EX     <= rs2data_ID;
	     rs1_EX         <= rs1_ID;
	     rs2_EX         <= rs2_ID;
	     rd_EX          <= rd_ID;
		  opcode_EX      <= opcode_ID;
		  funct3_EX      <= funct3_ID;
	
    end
	 end
endmodule: D_E_register
 
 
  