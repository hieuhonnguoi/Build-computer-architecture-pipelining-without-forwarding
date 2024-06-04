module pipelined(
   //input 
	input   logic           clk_i   ,
   input   logic           rst_ni  ,    
   input   logic   [31:0]  io_sw_i  ,
    
	//output
	output  logic   [31:0]  io_lcd_o,
	output  logic   [31:0]  io_ledg_o,
	output  logic   [31:0]  io_ledr_o,
	output  logic   [31:0]  io_hex0_o,
	output  logic   [31:0]  io_hex1_o,
	output  logic   [31:0]  io_hex2_o,
	output  logic   [31:0]  io_hex3_o,
	output  logic   [31:0]  io_hex4_o,
	output  logic   [31:0]  io_hex5_o,
	output  logic   [31:0]  io_hex6_o,
	output  logic   [31:0]  io_hex7_o,
	
	output logic    [31:0]  pc_debug_o	
);
   
    //IF stage declaration.......................................................................
	 logic [31:0]  PC_F;
	 logic         pc_taken_F;
	 logic [31:0]  PCPlus4_F;
	 logic [31:0]  PCNext_F;
	 logic [31:0]  PC_Branch_F;
	 logic [31:0]  Instr_F;

	 logic         stallF_F;
	 //...........................................................................................
	 //ID stage declaration.......................................................................
	 logic [31:0]  PC_D;
	 logic [31:0]  Instr_D;
 
	 logic [31:0]  rs1data_D;
    logic [31:0]  rs2data_D;
	 
	 logic         br_unsigned_D;
	 logic         jmp_sel_D;
	 logic         rd_wren_D;
	 logic         mem_wren_D;
	 logic         srcA_D;
	 logic         srcB_D;
	 logic [1:0]   wb_sel_D;
	 logic [3:0]   alu_control_D;
	 logic         stallD_D;
	 logic         flushD_D;
	 
 	 logic [2:0]   imm_sel_D;
	 logic [31:0]  immediate_D;
	 //...................................................................................
    //EX stage declaration........................................................................
	 logic [31:0]  alu_data_E;
	 logic         srcA_E;
	 logic         srcB_E;
	 logic [1:0]   wb_sel_E;
	 logic [3:0]   alu_control_E;
	 logic [31:0]  immediate_E;
	 logic [31:0]  PC_E;
	 logic [31:0]  rs1data_E;
	 logic [31:0]  rs2data_E;
	 logic [4:0]   rs1_E;
	 logic [4:0]   rs2_E;
	 logic [4:0]   rd_E;
	 logic         flushE_E;
	 logic         mem_wren_E;
	 logic         rd_wren_E;
	 logic [31:0]  PCNext_E;
	 logic [4:0]   opcode_E;
    logic [2:0]   funct3_E;
    logic         funct7b5_E;
	 logic         jmp_sel_E;
	 logic         br_unsigned_E;
	 logic         pctaken_E;
	 logic         br_less;
	 logic         br_equal;
	 logic [31:0]  alu_out_E;
	 logic [1:0]   forwardA_E;
	 logic [1:0]   forwardB_E;
	 logic [31:0]  dataA_E;
	 logic [31:0]  dataB_E;
	 logic [31:0]  operand_a_E;
	 logic [31:0]  operand_b_E;
	 //...............................................................................
    //Mem stage declaration........................................................
	 logic [31:0]  PC_M;
	 logic         rd_wren_M;
	 logic         mem_wren_M;
	 logic [1:0]   wb_sel_M;
	 logic [4:0]   rd_M;
	 logic [31:0]  alu_out_M;
	 logic [31:0]  dataB_M;
	 logic [31:0]  data_load_M;
	 logic [2:0]   funct3_M;
	 //.............................................................................
	 //Write back declaration.......................................................
	 logic [31:0]  PC_WB;
	 logic [31:0]  PCPlus4_WB;
	 logic         rd_wren_WB;
	 logic [4:0]   rd_WB;
	 logic [31:0]  data_load_WB;
	 logic [31:0]  alu_out_WB;
	 logic [31:0]  result_WB;
	 logic [1:0]   wb_sel_WB;
	 
	 
	 //......................IF stage...............................................
	 mux2_1 mux_pc(
	      .a_i      (PCPlus4_F),
			.b_i      (PC_Branch_F),
			.sel      (pc_taken_F),
			.result_o (PCNext_F)
	 );
	 pc pc_block(
	      .clk_i      (clk_i),
			.rst_ni     (rst_ni),
			.enable_ni  (stallF_F),
			.next_pc    (PCNext_F),
			.current_pc (PC_F),
			.pc_debug_o (pc_debug_o)
	 );
	 fulladder add_four_block(
	      .a_i   (PC_F),
			.b_i   (32'd4),
			.cin_i (1'b0),
			.cout_o(),
			.s_o   (PCPlus4_F)
	 );
	 imem imem_block (
        .clk_i   (clk_i) ,
        .rst_ni  (rst_ni) ,
        .addr_i  (PC_F[12:0]),
        .data_o  (Instr_F)
    );
	 F_D_register F_D_register(
	     .clk_i    (clk_i),
		  .rst_ni   (rst_ni),
		  .clear_i  (flushD_D),
		  .enable_ni (stallD_D),
		  .instr_IF (Instr_F),
		  .pc_IF    (PC_F),
		  .instr_ID (Instr_D),
		  .pc_ID    (PC_D)
	 );
		  
	 //......................................................................................
	 //....................................ID stage..........................................
	  ctrl_unit control_block(
	      //input
	      .instruction(Instr_D),
         //output
		   .jmp_sel(jmp_sel_D),  
		   .br_unsigned(br_unsigned_D), 
		   .rd_wren(rd_wren_D), 
		   .mem_wren(mem_wren_D), 
		   .op_a_sel(srcA_D),
		   .op_b_sel(srcB_D),
		   .wb_sel(wb_sel_D)
	 );
	  regfile regfile_block (
	     .clk_i   (clk_i),
        .rst_ni (rst_ni),
        .rs1_addr (Instr_D[19:15]) ,
        .rs2_addr (Instr_D[24:20]) ,
        .rd_addr (rd_WB),
        .rd_data (result_WB),
        .rd_wren (rd_wren_WB),
    
        .rs1_data(rs1data_D),
        .rs2_data(rs2data_D)
    );
	 immediate_generator imm_gen_block(
	     .inst(Instr_D[31:7]),
		  .imm_sel(imm_sel_D),
		  .immediate(immediate_D)
	 );
    immediate_decoder imm_decoder_block(
	     .instruction_i({Instr_D[31],Instr_D[6:2]}),
		  .u_flag_i(Instr_D[14:12]),
		  .imm_sel_o(imm_sel_D)
	 );
	 
	 alu_decoder alu_decoder_block(
	      .instruction (Instr_D[6:2]),
			.funct7b5    (Instr_D[30]),
	      .funct3      (Instr_D[14:12]),
	      .alu_control (alu_control_D)
	 );
	 
	 D_E_register D_E_register(
	 //input
	     .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .clear_i       (flushE_E),
		  .jmp_sel_ID    (jmp_sel_D),  
		  .br_unsigned_ID(br_unsigned_D),
        .reg_write_ID  (rd_wren_D),
		  .mem_write_ID  (mem_wren_D),
        .srcA_ID       (srcA_D),
        .srcB_ID       (srcB_D),
        .wb_sel_ID     (wb_sel_D),
        .alu_control_ID(alu_control_D),
        .immediate_ID  (immediate_D),
        .pc_ID         (PC_D),
		  .rs1data_ID    (rs1data_D),
		  .rs2data_ID    (rs2data_D),
		  .rs1_ID        (Instr_D[19:15]),
		  .rs2_ID        (Instr_D[24:20]),
        .rd_ID         (Instr_D[11:7]),
        .opcode_ID     (Instr_D[6:2]),
        .funct3_ID     (Instr_D[14:12]),
	 //output 
	     .jmp_sel_EX       (jmp_sel_E),  
		  .br_unsigned_EX   (br_unsigned_E),
	     .reg_write_EX  (rd_wren_E),
		  .mem_write_EX  (mem_wren_E),
        .srcA_EX       (srcA_E),
        .srcB_EX       (srcB_E),
        .wb_sel_EX     (wb_sel_E),
        .alu_control_EX(alu_control_E),
        .immediate_EX  (immediate_E),
        .pc_EX         (PC_E),
		  .rs1data_EX    (rs1data_E),
		  .rs2data_EX    (rs2data_E),
		  .rs1_EX        (rs1_E),
		  .rs2_EX        (rs2_E),
        .rd_EX         (rd_E),
        .opcode_EX     (opcode_E),
        .funct3_EX     (funct3_E)
        
	 );
	 //....................................................................................
	 //.............................EX stage..............................................
	 or_2 or_2(
	     .a_i      (pctaken_E),
		  .b_i      (jmp_sel_E),
		  .result_o (pc_taken_F)
	 );
	 brcomp brcomp_block(
	     .rs1_data(dataA_E),
		  .rs2_data(dataB_E),
		  .br_unsigned(br_unsigned_E),
		  .br_less(br_less),
		  .br_equal(br_equal)
	 );
	 mux3_1 forwardA(
	      .a_i(rs1data_E),
			.b_i(result_WB),
			.c_i(alu_out_M),
			.sel(forwardA_E),
			.result_o(dataA_E)
	 );
	 mux3_1 forwardB(
	      .a_i(rs2data_E),
			.b_i(result_WB),
			.c_i(alu_out_M),
			.sel(forwardB_E),
			.result_o(dataB_E)
	 );
	 mux2_1 mux_a(
	      .a_i      (dataA_E),
			.b_i      (PC_E),
			.sel      (srcA_E),
			.result_o  (operand_a_E)
	 );
	 mux2_1 mux_b(
	      .a_i      (dataB_E),
			.b_i      (immediate_E),
			.sel      (srcB_E),
			.result_o  (operand_b_E)
	 );
	 
	 alu alu_block(
	      .operand_a(operand_a_E),
		   .operand_b(operand_b_E),
		   .alu_control(alu_control_E),
		   .alu_data(alu_out_E)
	 );
	 fulladder PC_add(
	      .a_i   (PC_E),
			.b_i   (immediate_E),
			.cin_i (1'b0),
			.cout_o(),
			.s_o   (PC_Branch_F)
	 );
	 branch_decision branch_decision(
	      .opcodeE_i  (opcode_E),
			.funct3E_i  (funct3_E),
		   .br_less    (br_less),
		   .br_equal   (br_equal),
		   .br_sel     (pctaken_E)
	 );
	 
	 E_M_register E_M_register(
	      //input
	      .clk_i        (clk_i),
			.rst_ni       (rst_ni),
			.reg_write_EX (rd_wren_E),
			.mem_write_EX (mem_wren_E),
			.wb_sel_EX    (wb_sel_E),
			.rd_EX        (rd_E),
			.pc_EX        (PC_E),
			.alu_result_EX(alu_out_E),
			.rs2_data_EX  (dataB_E),
			.funct3_EX    (funct3_E),
			//output
			.reg_write_M  (rd_wren_M),
			.mem_write_M  (mem_wren_M),
			.wb_sel_M     (wb_sel_M),
			.rd_M         (rd_M),
			.pc_M         (PC_M),
			.alu_result_M (alu_out_M),
			.rs2_data_M   (dataB_M),
			.funct3_M     (funct3_M)
		);
	//...................................................................................
	//..............Mem stage............................................................
	 LSU LSU_block (
     	   .clk_i          (clk_i),        
         .rst_ni         (rst_ni),
         .addr_i         (alu_out_M),
         .st_data_i      (dataB_M),    
         .st_en_i        (mem_wren_M),    
         .io_sw_i        (io_sw_i),    
         .sel_mod        (funct3_M),     

         .ld_data_o      (data_load_M),    
         .io_lcd_o       (io_lcd_o),    
         .io_ledg_o      (io_ledg_o),    
         .io_ledr_o      (io_ledr_o),    
         .io_hex7_o      (io_hex7_o),
			.io_hex6_o      (io_hex6_o),
			.io_hex5_o      (io_hex5_o),
			.io_hex4_o      (io_hex4_o),
			.io_hex3_o      (io_hex3_o),
			.io_hex2_o      (io_hex2_o),
			.io_hex1_o      (io_hex1_o),
         .io_hex0_o      (io_hex0_o)
    );
	 
	 M_WB_register M_WB_register(
	      .clk_i        (clk_i),
			.rst_ni       (rst_ni),
			.reg_write_M  (rd_wren_M),
			.pc_M         (PC_M),
			.wb_sel_M     (wb_sel_M),
			.rd_M         (rd_M),
			.alu_out_M    (alu_out_M),
			.data_load_M  (data_load_M),
		
			.reg_write_WB (rd_wren_WB),
			.pc_WB        (PC_WB),
			.wb_sel_WB    (wb_sel_WB),
			.rd_WB        (rd_WB),
			.alu_out_WB   (alu_out_WB),
			.data_load_WB (data_load_WB)
	);
			
	 //.......................................................................................
	 //..............Write back stage.........................................................
	 
	 fulladder add_four_wb(
	      .a_i   (PC_WB),
			.b_i   (32'd4),
			.cin_i (1'b0),
			.cout_o(),
			.s_o   (PCPlus4_WB)
	 );
	 
    mux3_1 wb_data_block(
	      .a_i(data_load_WB),
			.b_i(alu_out_WB),
			.c_i(PCPlus4_WB),
			.sel(wb_sel_WB),
			.result_o(result_WB)
	 );

    hazard_detection_unit hazard_detection_unit(
	      .pc_takenE_i    (pc_taken_F),
			.regwrite_MEM_i (rd_wren_M),
			.regwrite_WB_i  (rd_wren_WB),
			.rs1_D_i        (Instr_D[19:15]),
			.rs2_D_i        (Instr_D[24:20]),
			.rd_MEM_i       (rd_M),
			.rs1_EX_i       (rs1_E),
			.rs2_EX_i       (rs2_E),
			.rd_EX_i        (rd_E),
			.rd_WB_i        (rd_WB),
			.wb_sel_EX_i    (wb_sel_E),
			.stallF_o       (stallF_F),
			.stallD_o       (stallD_D),
			.flushD_o       (flushD_D),
			.flushE_o       (flushE_E),
			.forwardA_o     (forwardA_E),
	      .forwardB_o     (forwardB_E)
	);
	 
	
endmodule: pipelined
