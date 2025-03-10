module sll(
    //input 
	 input logic [31:0] a_i,
	 input logic [4:0] b_i,
	 //output 
	 output logic [31:0]c_i);
	 always @(*) begin
	 case(b_i)
	 0: c_i = a_i;
	 1: c_i = {a_i[30:0], 1'b0};
	 2: c_i = {a_i[29:0], 2'b0};
	 3: c_i = {a_i[28:0], 3'b0};
	 4: c_i = {a_i[27:0], 4'b0};
	 5: c_i = {a_i[26:0], 5'b0};
	 6: c_i = {a_i[25:0], 6'b0};
	 7: c_i = {a_i[24:0], 7'b0};
	 8: c_i = {a_i[23:0], 8'b0};
	 9: c_i = {a_i[22:0], 9'b0};
	 10: c_i = {a_i[21:0], 10'b0};
	 11: c_i = {a_i[20:0], 11'b0};
	 12: c_i = {a_i[19:0], 12'b0};
	 13: c_i = {a_i[18:0], 13'b0};
	 14: c_i = {a_i[17:0], 14'b0};
	 15: c_i = {a_i[16:0], 15'b0};
	 16: c_i = {a_i[15:0], 16'b0};
	 17: c_i = {a_i[14:0], 17'b0};
	 18: c_i = {a_i[13:0], 18'b0};
	 19: c_i = {a_i[12:0], 19'b0};
	 20: c_i = {a_i[11:0], 20'b0};
	 21: c_i = {a_i[10:0], 21'b0};
	 22: c_i = {a_i[9:0], 22'b0};
	 23: c_i = {a_i[8:0], 23'b0};
	 24: c_i = {a_i[7:0], 24'b0};
	 25: c_i = {a_i[6:0], 25'b0};
	 26: c_i = {a_i[5:0], 26'b0};
	 27: c_i = {a_i[4:0], 27'b0};
	 28: c_i = {a_i[3:0], 28'b0};
	 29: c_i = {a_i[2:0], 29'b0};
	 30: c_i = {a_i[1:0], 30'b0};
	 31: c_i = 31'b0;
	 endcase 
	 end
endmodule 
	 
	 
	 