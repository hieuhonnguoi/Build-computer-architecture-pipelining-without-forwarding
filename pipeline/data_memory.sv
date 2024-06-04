
module data_memory #(  
    parameter int unsigned DMEM_W = 11, //2 KB => 11 bit
    parameter              BYTE   = 2'b00, //sel_mode
    parameter              HWORD  = 2'b01,
    parameter              WORD   = 2'b10
) (
  // APB Protocol
  input  logic [DMEM_W-1:0] paddr_i  , //addr_i[11:0]
  input  logic              penable_i, //1'b1
  input  logic              psel_i   , //1'b1
  input  logic              pwrite_i , //dmux_dmem_st_en
  input  logic [31:0]       pwdata_i ,//(st_data_in)
  input  logic [3:0]        pstrb_i  ,//pstrb =b,B,H,W
  input  logic [2:0]        sel_mod  ,//inst[14:12] inst[14] is lu
							//sel_mod_i
  output logic [31:0]       prdata_o ,//out
  output logic              pready_o,
  
  input  logic 	clk_i,
  input  logic  rst_ni
);
 //inst[14:12]
	  //000 lb
	  //001 lh
	  //010 lw
	  //100 lbu
	  //101 lhu
	  
  logic [3:0][7:0] dmem [0:2**(DMEM_W-2)-1];

  // Write
  always_ff @(posedge clk_i) begin : proc_data
    if (psel_i && penable_i && pwrite_i) begin
    // with 32 bit data, bitmask has 3 bits
    // in order to decide write 1 byte, 2 bytes or 4 bytes
      if (pstrb_i[0]) begin
        dmem[paddr_i[DMEM_W-1:2]][0] <= pwdata_i[ 7: 0];
      end
      if (pstrb_i[1]) begin
        dmem[paddr_i[DMEM_W-1:2]][1] <= pwdata_i[15: 8];
      end
      if (pstrb_i[2]) begin
        dmem[paddr_i[DMEM_W-1:2]][2] <= pwdata_i[23:16];
      end
      if (pstrb_i[3]) begin
        dmem[paddr_i[DMEM_W-1:2]][3] <= pwdata_i[31:24];
      end
    end
  end
     //read
     logic [31:0] prdata ;
	 always_comb begin
	     prdata = {dmem[paddr_i[DMEM_W-1:2]][3], dmem[paddr_i[DMEM_W-1:2]][2],
         dmem[paddr_i[DMEM_W-1:2]][1], dmem[paddr_i[DMEM_W-1:2]][0]};
       pready_o = 1'b1;
       if (sel_mod[1:0] == BYTE ) begin
            if (sel_mod[2] == 1'b1) begin
                //unsigned
                prdata_o = {24'b0, prdata[7:0]};
            end
            else begin
                //sign 
                prdata_o = {{24{prdata[7]}}, prdata[7:0]};
            end
       end 
       else if (sel_mod[1:0] == HWORD ) begin 
            if (sel_mod[2] == 1'b1) begin
                //unsigned
                prdata_o = {16'b0, prdata[15:0]};
            end 
            else begin
                //signed
                prdata_o = {{16{prdata[15]}}, prdata[15:0]};
            end
       end
       else if (sel_mod[1:0] == WORD ) begin
                prdata_o = prdata ;
       end
       else begin
                prdata_o = 32'hCAFECAFE;
       end

       //$writememh("./memory/data_mem.mem", dmem);
     end

endmodule  
