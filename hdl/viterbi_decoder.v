module viterbi_decoder(
	clk,						// fast clk, 8 times the input data clk 
	reset_n,					// active low async reset
	
	yn_in0,						// input 
	yn_in1,						// input
	yn_in2,						// input
	decoded_bit_out, 				// decoded bit
	
	wdata_out, 					// write data to 6 banks
	rdata0_in, 					// read data from bank0
	rdata1_in, 					// read data from bank1 
	rdata2_in, 					// read data from bank2 
	rdata3_in, 					// read data from bank3
	rdata4_in, 					// read data from bank4
	rdata5_in, 					// read data from bank5 
	addr0_out,					// address to bank0 
	addr1_out,					// address to bank1 
	addr2_out,					// address to bank2 
	addr3_out,					// address to bank3 
	addr4_out,					// address to bank4
	addr5_out,					// address to bank5
	we_out,						// active high write strobe to 6 banks 
	cs_out, 					// active high chip select to 6 banks

	clk_div2_out					// clk divided by 2, use for input sync
);

input clk;
input [3:0] yn_in0; 
input [3:0] yn_in1;
input [3:0] yn_in2;
output decoded_bit_out;
input reset_n; 
output [63:0] wdata_out;
input  [63:0] rdata0_in; 
input  [63:0] rdata1_in; 
input  [63:0] rdata2_in; 
input  [63:0] rdata3_in;
input  [63:0] rdata4_in;
input  [63:0] rdata5_in;
output [4:0] addr0_out; 
output [4:0] addr1_out; 
output [4:0] addr2_out; 
output [4:0] addr3_out;
output [4:0] addr4_out;
output [4:0] addr5_out;
output [5:0] we_out;
output [5:0] cs_out; 
output clk_div2_out;


wire[5:0]	s0, s1, s2, s3, s4, s5, s6, s7;
wire [63:0] sel;
wire		stack_toggle;
wire		reverse_decoded_bit;

wire clk_div2;
assign clk_div2_out = clk_div2;

BMU u0(
	.yn_in0(yn_in0), 
	.yn_in1(yn_in1),
	.yn_in2(yn_in2),
	.dis_000_out(s0), 
	.dis_001_out(s1), 
	.dis_010_out(s2), 
	.dis_011_out(s3),
	.dis_100_out(s4), 
	.dis_101_out(s5), 
	.dis_110_out(s6), 
	.dis_111_out(s7)
);

PMU u1(
	.clk(clk),
	.reset_n(reset_n),
	.bm_000_in(s0),
	.bm_001_in(s1),
	.bm_010_in(s2),
	.bm_011_in(s3),
	.bm_100_in(s4),
	.bm_101_in(s5),
	.bm_110_in(s6),
	.bm_111_in(s7),
	.sel_out(sel),
	.clk_div2_out(clk_div2)
);


SPMU u2(
	.clk(clk_div2),
	.reset_n(reset_n),
	.sel_in(sel),
	.rdata0_in(rdata0_in),
	.rdata1_in(rdata1_in),
	.rdata2_in(rdata2_in),
	.rdata3_in(rdata3_in),
	.rdata4_in(rdata4_in),
	.rdata5_in(rdata5_in),
	.addr0_out(addr0_out),
	.addr1_out(addr1_out),
	.addr2_out(addr2_out),
	.addr3_out(addr3_out),
	.addr4_out(addr4_out),
	.addr5_out(addr5_out),
	.wdata_out(wdata_out),
	.cs_out(cs_out),
	.we_out(we_out),
	.reverse_decoded_bit(reverse_decoded_bit),
	.stack_toggle(stack_toggle)
);

RSTK u3(
	.clk(clk_div2),
	.reset_n(reset_n),
	.stack_toggle(stack_toggle),
	.decode_in(reverse_decoded_bit),
	.reverse_out(decoded_bit_out)
);

endmodule





