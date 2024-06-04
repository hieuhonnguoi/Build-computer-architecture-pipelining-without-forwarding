
module LSU
#(
    //parameter for data memory
    parameter                    BYTE          = 2'b00,
    parameter                    HWORD         = 2'b01,
    parameter                    WORD          = 2'b10,
    //parameter for memory mapping 
    parameter                    DATA_MEMORY     = 2'b00,
    parameter                    OUT_PERIPHERALS = 2'b01,
    parameter                    IN_PERIPHERALS  = 2'b10,
    parameter                    RESERVED        = 2'b11
    
)
(
    //input
    input     logic              clk_i,
    input     logic              rst_ni,
    input     logic    [31:0]    addr_i,	
    input     logic    [31:0]    st_data_i,//data
    input     logic              st_en_i, //1 to write and 0 to read
    input     logic    [31:0]    io_sw_i,
    input     logic    [2:0]     sel_mod,//2: sign, 1:0 b,B,H,W
    //output 
	 output logic [31:0] ld_data_o,
    output logic [31:0] io_lcd_o ,
    output logic [31:0] io_ledg_o,
    output logic [31:0] io_ledr_o,
    output logic [31:0] io_hex7_o,
	 output logic [31:0] io_hex6_o,
	 output logic [31:0] io_hex5_o,
	 output logic [31:0] io_hex4_o,
	 output logic [31:0] io_hex3_o,
	 output logic [31:0] io_hex2_o,
	 output logic [31:0] io_hex1_o,
	 output logic [31:0] io_hex0_o
    
);
    logic              [1:0]     addr_sel;
    /* for internal signal: [src]_[des]_[signal_name]*/
    
    logic              [31:0]    dmem_mux_lddata; // this wire connect dmem's output to mux's input  
    logic              [31:0]    oper_mux_lddata;
    logic              [31:0]    iper_mux_lddata;
    //signal to dmem after de-mux
    logic                        dmux_dmem_st_en;
    //signal to out peripherals after demux
    logic                        dmux_oper_st_en;
    //input pheripherals reg
    logic              [31:0]    input_per_reg ;
    //output peripherals reg
    logic              [3:0][7:0]    output_per_reg   [10:0] ;
    //pstrb
    logic              [3:0]     pstrb ;
    //-------------generate addr_sel----------------//
    always_comb begin
        if ((addr_i[15:8] == 8'h00) || (addr_i[15:8] == 8'h01) || (addr_i[15:8] == 8'h02) || (addr_i[15:8] == 8'h03)|| (addr_i[15:8] == 8'h04)|| (addr_i[15:8] == 8'h05)|| (addr_i[15:8] == 8'h06)|| (addr_i[15:8] == 8'h07)) begin 
            addr_sel = DATA_MEMORY;
        end 
        else if (addr_i[15:8] == 8'h08) begin 
            addr_sel = OUT_PERIPHERALS;
        end
        else if (addr_i[15:8] == 8'h09) begin 
            addr_sel = IN_PERIPHERALS;
        end
        else begin 
            addr_sel = RESERVED;
        end      
    end 
	
    //de-mux for and st_en_i
    always_comb begin 
     case (addr_sel) 
        DATA_MEMORY : begin 
            //dmem
            dmux_dmem_st_en   = st_en_i ;
            //output peripherals
            dmux_oper_st_en   = 1'b0    ;
        end
        OUT_PERIPHERALS : begin 
            dmux_dmem_st_en   = 1'b0    ;
            //output peripherals
            dmux_oper_st_en   = st_en_i ;           
            
        end
        IN_PERIPHERALS : begin 
            dmux_dmem_st_en   = 1'b0    ;
            //output peripherals
            dmux_oper_st_en   = 1'b0    ;       
        end 
        RESERVED : begin 
            dmux_dmem_st_en   = 1'b0    ;
            //output peripherals
            dmux_oper_st_en   = 1'b0    ;  
        end 
        default : begin 
        end 
     endcase
    
    end
   
    always_comb begin 
   		    if (addr_i[15:0] == 16'h0900) begin 
                input_per_reg = io_sw_i;
            end
            else begin 
                input_per_reg  = 32'b1 ;
            end 
    end
    
    always_comb begin 
        if (addr_i[15:0] == 16'h0900) begin
            iper_mux_lddata = input_per_reg ;
        end
        else begin 
            iper_mux_lddata = 32'hCAFECAFE ;
        end 
    end 
    
   
    always_ff @(posedge clk_i) begin
        if (dmux_oper_st_en) begin
            case (addr_i[15:0])
                16'h0800 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[0][0] <= st_data_i[7:0];
                        output_per_reg[0][1] <= output_per_reg[0][1]; 
                        output_per_reg[0][2] <= output_per_reg[0][2] ; 
                        output_per_reg[0][3] <= output_per_reg[0][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[0][0] <= st_data_i[7:0];
                        output_per_reg[0][1] <= st_data_i[15:8]; 
                        output_per_reg[0][2] <= output_per_reg[0][2] ; 
                        output_per_reg[0][3] <= output_per_reg[0][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[0][0] <= st_data_i[7:0];
                        output_per_reg[0][1] <= st_data_i[15:8]; 
                        output_per_reg[0][2] <= st_data_i[23:16];
                        output_per_reg[0][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[0][0] <= output_per_reg[0][0];
                        output_per_reg[0][1] <= output_per_reg[0][1]; 
                        output_per_reg[0][2] <= output_per_reg[0][2] ; 
                        output_per_reg[0][3] <= output_per_reg[0][3]  ;
                   end
                end
                16'h0810 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[1][0] <= st_data_i[7:0];
                        output_per_reg[1][1] <= output_per_reg[1][1]; 
                        output_per_reg[1][2] <= output_per_reg[1][2] ; 
                        output_per_reg[1][3] <= output_per_reg[1][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[1][0] <= st_data_i[7:0];
                        output_per_reg[1][1] <= st_data_i[15:8]; 
                        output_per_reg[1][2] <= output_per_reg[1][2] ; 
                        output_per_reg[1][3] <= output_per_reg[1][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[1][0] <= st_data_i[7:0];
                        output_per_reg[1][1] <= st_data_i[15:8]; 
                        output_per_reg[1][2] <= st_data_i[23:16];
                        output_per_reg[1][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[1][0] <= output_per_reg[1][0];
                        output_per_reg[1][1] <= output_per_reg[1][1]; 
                        output_per_reg[1][2] <= output_per_reg[1][2] ; 
                        output_per_reg[1][3] <= output_per_reg[1][3]  ;
                   end
                end
                16'h0820 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[2][0] <= st_data_i[7:0];
                        output_per_reg[2][1] <= output_per_reg[2][1]; 
                        output_per_reg[2][2] <= output_per_reg[2][2] ; 
                        output_per_reg[2][3] <= output_per_reg[2][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[2][0] <= st_data_i[7:0];
                        output_per_reg[2][1] <= st_data_i[15:8]; 
                        output_per_reg[2][2] <= output_per_reg[2][2] ; 
                        output_per_reg[2][3] <= output_per_reg[2][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[2][0] <= st_data_i[7:0];
                        output_per_reg[2][1] <= st_data_i[15:8]; 
                        output_per_reg[2][2] <= st_data_i[23:16];
                        output_per_reg[2][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[2][0] <= output_per_reg[2][0];
                        output_per_reg[2][1] <= output_per_reg[2][1]; 
                        output_per_reg[2][2] <= output_per_reg[2][2] ; 
                        output_per_reg[2][3] <= output_per_reg[2][3]  ;
                   end
                end
                16'h0830 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[3][0] <= st_data_i[7:0];
                        output_per_reg[3][1] <= output_per_reg[3][1]; 
                        output_per_reg[3][2] <= output_per_reg[3][2] ; 
                        output_per_reg[3][3] <= output_per_reg[3][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[3][0] <= st_data_i[7:0];
                        output_per_reg[3][1] <= st_data_i[15:8]; 
                        output_per_reg[3][2] <= output_per_reg[3][2] ; 
                        output_per_reg[3][3] <= output_per_reg[3][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[3][0] <= st_data_i[7:0];
                        output_per_reg[3][1] <= st_data_i[15:8]; 
                        output_per_reg[3][2] <= st_data_i[23:16];
                        output_per_reg[3][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[3][0] <= output_per_reg[3][0];
                        output_per_reg[3][1] <= output_per_reg[3][1]; 
                        output_per_reg[3][2] <= output_per_reg[3][2] ; 
                        output_per_reg[3][3] <= output_per_reg[3][3]  ;
                   end
                end
                16'h0840 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[4][0] <= st_data_i[7:0];
                        output_per_reg[4][1] <= output_per_reg[4][1]; 
                        output_per_reg[4][2] <= output_per_reg[4][2] ; 
                        output_per_reg[4][3] <= output_per_reg[4][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[4][0] <= st_data_i[7:0];
                        output_per_reg[4][1] <= st_data_i[15:8]; 
                        output_per_reg[4][2] <= output_per_reg[4][2] ; 
                        output_per_reg[4][3] <= output_per_reg[4][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[4][0] <= st_data_i[7:0];
                        output_per_reg[4][1] <= st_data_i[15:8]; 
                        output_per_reg[4][2] <= st_data_i[23:16];
                        output_per_reg[4][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[4][0] <= output_per_reg[0][0];
                        output_per_reg[4][1] <= output_per_reg[0][1]; 
                        output_per_reg[4][2] <= output_per_reg[0][2] ; 
                        output_per_reg[4][3] <= output_per_reg[0][3]  ;
                   end
                end
                16'h0850 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[5][0] <= st_data_i[7:0];
                        output_per_reg[5][1] <= output_per_reg[5][1]; 
                        output_per_reg[5][2] <= output_per_reg[5][2] ; 
                        output_per_reg[5][3] <= output_per_reg[5][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[5][0] <= st_data_i[7:0];
                        output_per_reg[5][1] <= st_data_i[15:8]; 
                        output_per_reg[5][2] <= output_per_reg[5][2] ; 
                        output_per_reg[5][3] <= output_per_reg[5][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[5][0] <= st_data_i[7:0];
                        output_per_reg[5][1] <= st_data_i[15:8]; 
                        output_per_reg[5][2] <= st_data_i[23:16];
                        output_per_reg[5][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[5][0] <= output_per_reg[5][0];
                        output_per_reg[5][1] <= output_per_reg[5][1]; 
                        output_per_reg[5][2] <= output_per_reg[5][2] ; 
                        output_per_reg[5][3] <= output_per_reg[5][3]  ;
                   end
                end
                16'h0860 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[6][0] <= st_data_i[7:0];
                        output_per_reg[6][1] <= output_per_reg[6][1]; 
                        output_per_reg[6][2] <= output_per_reg[6][2] ; 
                        output_per_reg[6][3] <= output_per_reg[6][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[6][0] <= st_data_i[7:0];
                        output_per_reg[6][1] <= st_data_i[15:8]; 
                        output_per_reg[6][2] <= output_per_reg[6][2] ; 
                        output_per_reg[6][3] <= output_per_reg[6][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[6][0] <= st_data_i[7:0];
                        output_per_reg[6][1] <= st_data_i[15:8]; 
                        output_per_reg[6][2] <= st_data_i[23:16];
                        output_per_reg[6][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[6][0] <= output_per_reg[6][0];
                        output_per_reg[6][1] <= output_per_reg[6][1]; 
                        output_per_reg[6][2] <= output_per_reg[6][2] ; 
                        output_per_reg[6][3] <= output_per_reg[6][3]  ;
                   end
                end
                16'h0870 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[7][0] <= st_data_i[7:0];
                        output_per_reg[7][1] <= output_per_reg[7][1]; 
                        output_per_reg[7][2] <= output_per_reg[7][2] ; 
                        output_per_reg[7][3] <= output_per_reg[7][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[7][0] <= st_data_i[7:0];
                        output_per_reg[7][1] <= st_data_i[15:8]; 
                        output_per_reg[7][2] <= output_per_reg[7][2] ; 
                        output_per_reg[7][3] <= output_per_reg[7][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[7][0] <= st_data_i[7:0];
                        output_per_reg[7][1] <= st_data_i[15:8]; 
                        output_per_reg[7][2] <= st_data_i[23:16];
                        output_per_reg[7][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[7][0] <= output_per_reg[7][0];
                        output_per_reg[7][1] <= output_per_reg[7][1]; 
                        output_per_reg[7][2] <= output_per_reg[7][2] ; 
                        output_per_reg[7][3] <= output_per_reg[7][3]  ;
                   end
                end
                16'h0880 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[8][0] <= st_data_i[7:0];
                        output_per_reg[8][1] <= output_per_reg[8][1]; 
                        output_per_reg[8][2] <= output_per_reg[8][2] ; 
                        output_per_reg[8][3] <= output_per_reg[8][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[8][0] <= st_data_i[7:0];
                        output_per_reg[8][1] <= st_data_i[15:8]; 
                        output_per_reg[8][2] <= output_per_reg[8][2] ; 
                        output_per_reg[8][3] <= output_per_reg[8][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[8][0] <= st_data_i[7:0];
                        output_per_reg[8][1] <= st_data_i[15:8]; 
                        output_per_reg[8][2] <= st_data_i[23:16];
                        output_per_reg[8][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[8][0] <= output_per_reg[8][0];
                        output_per_reg[8][1] <= output_per_reg[8][1]; 
                        output_per_reg[8][2] <= output_per_reg[8][2] ; 
                        output_per_reg[8][3] <= output_per_reg[8][3]  ;
                   end
                end
                16'h0890 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[9][0] <= st_data_i[7:0];
                        output_per_reg[9][1] <= output_per_reg[9][1]; 
                        output_per_reg[9][2] <= output_per_reg[9][2] ; 
                        output_per_reg[9][3] <= output_per_reg[9][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[9][0] <= st_data_i[7:0];
                        output_per_reg[9][1] <= st_data_i[15:8]; 
                        output_per_reg[9][2] <= output_per_reg[9][2] ; 
                        output_per_reg[9][3] <= output_per_reg[9][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[9][0] <= st_data_i[7:0];
                        output_per_reg[9][1] <= st_data_i[15:8]; 
                        output_per_reg[9][2] <= st_data_i[23:16];
                        output_per_reg[9][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[9][0] <= output_per_reg[9][0];
                        output_per_reg[9][1] <= output_per_reg[9][1]; 
                        output_per_reg[9][2] <= output_per_reg[9][2] ; 
                        output_per_reg[9][3] <= output_per_reg[9][3]  ;
                   end
                end
                16'h08A0 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        output_per_reg[10][0] <= st_data_i[7:0];
                        output_per_reg[10][1] <= output_per_reg[10][1]; 
                        output_per_reg[10][2] <= output_per_reg[10][2] ; 
                        output_per_reg[10][3] <= output_per_reg[10][3]  ;
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        output_per_reg[10][0] <= st_data_i[7:0];
                        output_per_reg[10][1] <= st_data_i[15:8]; 
                        output_per_reg[10][2] <= output_per_reg[10][2] ; 
                        output_per_reg[10][3] <= output_per_reg[10][3] ; 
                    end
                    else if (sel_mod[1:0] == WORD) begin
                        output_per_reg[10][0] <= st_data_i[7:0];
                        output_per_reg[10][1] <= st_data_i[15:8]; 
                        output_per_reg[10][2] <= st_data_i[23:16];
                        output_per_reg[10][3] <= st_data_i[31:24];  
                   end
                   else begin
                        output_per_reg[10][0] <= output_per_reg[10][0];
                        output_per_reg[10][1] <= output_per_reg[10][1]; 
                        output_per_reg[10][2] <= output_per_reg[10][2] ; 
                        output_per_reg[10][3] <= output_per_reg[10][3]  ;
                   end
                end
                default begin
                        output_per_reg[10][0] <= output_per_reg[10][0];
                        output_per_reg[10][1] <= output_per_reg[10][1]; 
                        output_per_reg[10][2] <= output_per_reg[10][2] ; 
                        output_per_reg[10][3] <= output_per_reg[10][3]  ;
                end
            endcase
        end
    end

   //read 
    always_comb begin 
        if (!dmux_oper_st_en) begin 
            case (addr_i[15:0]) 
                16'h0800 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[0][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[0][0][7]}}, output_per_reg[0][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[0][1],
                            output_per_reg[0][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[0][1][7]}}, output_per_reg[0][1],
                            output_per_reg[0][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[0];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0810 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[1][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[1][0][7]}}, output_per_reg[1][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[1][1],
                            output_per_reg[1][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[1][1][7]}}, output_per_reg[1][1],
                            output_per_reg[1][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[1];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0820 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[2][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[2][0][7]}}, output_per_reg[2][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[2][1],
                            output_per_reg[2][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[2][1][7]}}, output_per_reg[2][1],
                            output_per_reg[2][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[2];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0830 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[3][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[3][0][7]}}, output_per_reg[3][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[3][1],
                            output_per_reg[3][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[3][1][7]}}, output_per_reg[3][1],
                            output_per_reg[3][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[3];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0840 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[4][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[4][0][7]}}, output_per_reg[4][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[4][1],
                            output_per_reg[4][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[4][1][7]}}, output_per_reg[4][1],
                            output_per_reg[4][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[4];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0850 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[5][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[5][0][7]}}, output_per_reg[5][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[5][1],
                            output_per_reg[5][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[5][1][7]}}, output_per_reg[5][1],
                            output_per_reg[5][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[5];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0860 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[6][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[6][0][7]}}, output_per_reg[6][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[6][1],
                            output_per_reg[6][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[6][1][7]}}, output_per_reg[6][1],
                            output_per_reg[6][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[6];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0870 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[7][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[7][0][7]}}, output_per_reg[7][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[7][1],
                            output_per_reg[7][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[7][1][7]}}, output_per_reg[7][1],
                            output_per_reg[7][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[7];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0880 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[8][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[8][0][7]}}, output_per_reg[8][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[8][1],
                            output_per_reg[8][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[8][1][7]}}, output_per_reg[8][1],
                            output_per_reg[8][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[8];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h0890 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[9][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[9][0][7]}}, output_per_reg[9][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[9][1],
                            output_per_reg[9][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[9][1][7]}}, output_per_reg[9][1],
                            output_per_reg[9][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[9];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                16'h08A0 : begin
                    if (sel_mod[1:0] == BYTE) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {24'b0, output_per_reg[10][0]};
                        end
                        else begin
                            //signedA
                            oper_mux_lddata = {{24{output_per_reg[10][0][7]}},
                            output_per_reg[10][0]};
                        end
                    end
                    else if (sel_mod[1:0] == HWORD) begin
                        if (sel_mod[2] == 1'b1) begin
                            //unsigned
                            oper_mux_lddata = {16'b0, output_per_reg[10][1],
                            output_per_reg[10][0]};
                        end
                        else begin
                            //signed
                            oper_mux_lddata = {{16{output_per_reg[10][1][7]}},
                            output_per_reg[10][1],
                            output_per_reg[10][0]};
                        end
                    end
                    else if (sel_mod == WORD) begin
                        oper_mux_lddata = output_per_reg[10];
                    end
                    else begin
                        oper_mux_lddata = 32'hCAFECAFE;
                    end
                end
                default  : begin 
                    oper_mux_lddata = 32'hCAFECAFE;
                end
            endcase 
        end 
        else begin  
            oper_mux_lddata = 32'hCAFECAFE ;
        end
    end 
    //-------------- data mem-----------------//
/* verilator lint_off PINCONNECTEMPTY */
    always_comb begin
         if (sel_mod[1:0] == BYTE) begin
            pstrb = 4'b0001;
         end 
         else if (sel_mod[1:0] == HWORD) begin
            pstrb = 4'b0011;
         end
         else if (sel_mod[1:0] == WORD) begin
            pstrb = 4'b1111;
         end
         else begin
            pstrb = 4'b0000;
         end
    end
    
    data_memory  data_memory_inst
    (
        //input 
        .clk_i          (clk_i),
        .rst_ni         (rst_ni),
        .paddr_i        (addr_i[11:0]),
		.sel_mod        (sel_mod), 
        .pwdata_i       (st_data_i),
        .pwrite_i       (dmux_dmem_st_en),
		  .penable_i	(1'b1),
        .psel_i   	    (1'b1),
        .pstrb_i  	    (pstrb),
        .pready_o       (),
        //output
        .prdata_o       (dmem_mux_lddata)
        
    );
/* verilator lint_on PINCONNECTEMPTY */	 
         

    //mux for ld_data_o
    logic [31:0] ld_data;
    always_comb begin 
        case (addr_sel)
            DATA_MEMORY : begin 
                ld_data = dmem_mux_lddata ;
            end
            OUT_PERIPHERALS : begin 
                ld_data = oper_mux_lddata ;
            end
            IN_PERIPHERALS : begin 
                ld_data = iper_mux_lddata ;
            end
            RESERVED : begin 
                ld_data = 32'b1 ;
            end
            default : begin 
            end 
            
        endcase
        
    end 
    always_comb begin 
        case (sel_mod[1:0]) 
            BYTE : begin
                if (sel_mod[2] == 1'b1) begin 
                    //usigned 
                    ld_data_o = ld_data & 32'h000000FF;
                end 
                else begin 
                    //signed
                    if (ld_data[7] == 1'b1) begin 
                        ld_data_o = ld_data & 32'h000000FF | 32'hFFFFFF00;
                    end
                    else begin 
                        ld_data_o = ld_data & 32'h000000FF;
                    end
                end
            end
            HWORD : begin
                if (sel_mod[2] == 1'b1) begin 
                    // unsigned 
                    ld_data_o = ld_data & 32'h0000FFFF;
                end 
                else begin 
                    //signed
                    if (ld_data[15] == 1'b1) begin 
                        ld_data_o = ld_data & 32'h0000FFFF | 32'hFFFF0000;
                    end
                    else begin 
                        ld_data_o = ld_data & 32'h0000FFFF;
                    end
                end
            end
            WORD : begin 
                ld_data_o = ld_data;
            end
            default : begin 
                ld_data_o = 32'hCAFECAFE;
            end
        endcase

    end

    //peripherals output 
    assign io_lcd_o      = output_per_reg[10]  ;
    assign io_ledg_o     = output_per_reg[9]   ;
    assign io_ledr_o     = output_per_reg[8]   ;
    assign io_hex0_o     = output_per_reg[0]   ;
    assign io_hex1_o     = output_per_reg[1]    ;
    assign io_hex2_o     = output_per_reg[2]    ;
    assign io_hex3_o     = output_per_reg[3]    ;
    assign io_hex4_o     = output_per_reg[4]    ;
    assign io_hex5_o     = output_per_reg[5]    ;
    assign io_hex6_o     = output_per_reg[6]    ;
    assign io_hex7_o     = output_per_reg[7]    ;
    //--------------------(^_^)--------------------//
endmodule  
