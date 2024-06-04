module hazard_detection_unit(
  //input
  input logic pc_takenE_i,
  input logic regwrite_MEM_i, 
  input logic regwrite_WB_i,
  input logic  [4:0] rs1_D_i,
  input logic  [4:0] rs2_D_i,
  input logic  [4:0] rd_MEM_i,
  input logic  [4:0] rs1_EX_i,
  input logic  [4:0] rs2_EX_i,
  input logic  [4:0] rd_EX_i,
  input logic  [4:0] rd_WB_i,

  input logic  [1:0] wb_sel_EX_i,
  //output
  output logic stallF_o,
  output logic stallD_o,
  output logic flushD_o,
  output logic flushE_o,
  
  output logic [1:0] forwardA_o, 
  output logic [1:0] forwardB_o
);

    logic lwstall_o; 
	 
    // forwarding...................................
    always_comb begin
	 if(regwrite_MEM_i & (rd_MEM_i != 0) & (rd_MEM_i == rs1_EX_i))
	      forwardA_o = 2'b10;
	 else if (regwrite_WB_i & (rd_WB_i !=0 ) & (rd_WB_i == rs1_EX_i) & !(regwrite_MEM_i & (rd_MEM_i != 0) & (rd_MEM_i == rs1_EX_i)))
         forwardA_o = 2'b01;
	 else forwardA_o = 2'b00;
	 end
	 
	 always_comb begin
	 if((regwrite_MEM_i)& (rd_MEM_i != 0) & (rd_MEM_i == rs2_EX_i))
	      forwardB_o = 2'b10;
	 else if (regwrite_WB_i & (rd_WB_i !=0 ) & 
	         (rd_WB_i == rs2_EX_i) & !(regwrite_MEM_i & (rd_MEM_i != 0) & (rd_MEM_i == rs2_EX_i)))
         forwardB_o = 2'b01;
	 else forwardB_o = 2'b00;
	 end   
	 //.......................................................
	 //........................stall for load-use data hazard.............
	 always_comb begin
	 if(((rs1_D_i == rd_EX_i) | (rs2_D_i == rd_EX_i)) & (rd_EX_i !=0) & wb_sel_EX_i == 2'b00)
	      lwstall_o = 1'b1;
	 else lwstall_o = 1'b0;
	 end
	 assign stallF_o = lwstall_o;
	 assign stallD_o = lwstall_o;
	 assign flushE_o = lwstall_o | pc_takenE_i;
	 assign flushD_o = pc_takenE_i;
	 
endmodule