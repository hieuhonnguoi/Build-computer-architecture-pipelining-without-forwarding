`timescale 1ns/1ns


module pipelined_tb;

   logic clk_i;
	logic rst_ni;
	logic   [31:0]  io_sw_i;
	logic   [31:0]  io_lcd_o ;
	logic   [31:0]  io_ledg_o;
	logic   [31:0]  io_ledr_o;
	logic   [31:0]  io_hex0_o;
	logic   [31:0]  io_hex1_o;
	logic   [31:0]  io_hex2_o;
	logic   [31:0]  io_hex3_o;
	logic   [31:0]  io_hex4_o;
	logic   [31:0]  io_hex5_o;
	logic   [31:0]  io_hex6_o;
	logic   [31:0]  io_hex7_o;
	logic   [31:0]  pc_debug_o;
   pipelined dut(
	     .clk_i(clk_i),
        .rst_ni(rst_ni),
        .io_sw_i(io_sw_i),        
        .io_lcd_o(io_lcd_o),
        .io_ledg_o(io_ledg_o),
        .io_ledr_o(io_ledr_o),
        .io_hex0_o(io_hex0_o),
        .io_hex1_o(io_hex1_o),
        .io_hex2_o(io_hex2_o),
        .io_hex3_o(io_hex3_o),
        .io_hex4_o(io_hex4_o),
        .io_hex5_o(io_hex5_o),
        .io_hex6_o(io_hex6_o),
        .io_hex7_o(io_hex7_o),
        .pc_debug_o(pc_debug_o)
    );
	  always  #1 clk_i = ~clk_i;  

    // Stimulus
    initial begin
	     clk_i =1'b0;
        io_sw_i = 32'h0000_0002;
		  rst_ni = 1'd0;
        #3
        rst_ni=1'd1;
        $display("At the time %0t,de-assert set",$time);
		  #30 
		  io_sw_i = 32'h0000_0005;
		  #500
		  io_sw_i = 32'h0000_0006;
		  #1000
		  io_sw_i = 32'h0000_0007;
		  #1500
		  io_sw_i = 32'h0000_000A;
		  
    end

    // always @(posedge clk_i) begin
    //     $display("PC Debug: %h", pc_debug_o);
    // end

endmodule