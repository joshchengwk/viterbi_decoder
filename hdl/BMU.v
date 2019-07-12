//===========================================
//Branch metric unit for viterbi decoder
//EESM518 final project
//Wai Kin Cheng
//Lo Hon Yik
//===========================================
module BMU(
	yn_in0, 
	yn_in1,
	yn_in2,
	dis_000_out, 
	dis_001_out, 
	dis_010_out, 
	dis_011_out,
	dis_100_out, 
	dis_101_out, 
	dis_110_out, 
	dis_111_out
);

//-----------------
//Input/output
//-----------------
input			[3:0]	yn_in0; 
input			[3:0]	yn_in1;
input			[3:0]	yn_in2;
output			[5:0]	dis_000_out;
output			[5:0]	dis_001_out;
output			[5:0]	dis_010_out;
output			[5:0]	dis_011_out;
output			[5:0]	dis_100_out;
output			[5:0]	dis_101_out;
output			[5:0]	dis_110_out;
output			[5:0]	dis_111_out;

//---------------
//sign extension
//---------------
wire			[5:0]	yn_in0_ext; 
wire			[5:0]	yn_in1_ext;
wire			[5:0]	yn_in2_ext;

//------------------
//sign invert
//------------------ 
wire			[5:0]	yn_in0_ext_n;
wire			[5:0]	yn_in1_ext_n;
wire			[5:0]	yn_in2_ext_n;

//------------------
//hamming distance
//------------------
wire			[5:0]	dis_000;
wire			[5:0]	dis_001;
wire			[5:0]	dis_010;
wire			[5:0]	dis_011;
wire			[5:0]	dis_100;
wire			[5:0]	dis_101;
wire			[5:0]	dis_110;
wire			[5:0]	dis_111;

//--------------------------
//hamming distance output
//--------------------------
wire			[5:0]	dis_000_out;
wire			[5:0]	dis_001_out;
wire			[5:0]	dis_010_out;
wire			[5:0]	dis_011_out;
wire			[5:0]	dis_100_out;
wire			[5:0]	dis_101_out;
wire			[5:0]	dis_110_out;
wire			[5:0]	dis_111_out;

//Sign extension for output
assign yn_in0_ext = {yn_in0[3], yn_in0[3], yn_in0};
assign yn_in1_ext = {yn_in1[3], yn_in1[3], yn_in1}; 
assign yn_in2_ext = {yn_in2[3], yn_in2[3], yn_in2}; 

//invert extended input
assign yn_in0_ext_n = ~yn_in0_ext + 1;
assign yn_in1_ext_n = ~yn_in1_ext + 1;
assign yn_in2_ext_n = ~yn_in2_ext + 1;

//calculate hamming distance by euclidean square

assign dis_000 = yn_in2_ext_n + yn_in1_ext_n + yn_in0_ext_n;
assign dis_001 = yn_in2_ext_n + yn_in1_ext_n + yn_in0_ext;
assign dis_010 = yn_in2_ext_n + yn_in1_ext + yn_in0_ext_n;
assign dis_011 = yn_in2_ext_n + yn_in1_ext + yn_in0_ext;
assign dis_100 = yn_in2_ext + yn_in1_ext_n + yn_in0_ext_n;
assign dis_101 = yn_in2_ext + yn_in1_ext_n + yn_in0_ext;
assign dis_110 = yn_in2_ext + yn_in1_ext + yn_in0_ext_n;
assign dis_111 = yn_in2_ext + yn_in1_ext + yn_in0_ext;

/*
assign dis_000 = yn_in2_ext + yn_in1_ext + yn_in0_ext;
assign dis_001 = yn_in2_ext + yn_in1_ext + yn_in0_ext_n;
assign dis_010 = yn_in2_ext + yn_in1_ext_n + yn_in0_ext;
assign dis_011 = yn_in2_ext + yn_in1_ext_n + yn_in0_ext_n;
assign dis_100 = yn_in2_ext_n + yn_in1_ext + yn_in0_ext;
assign dis_101 = yn_in2_ext_n + yn_in1_ext + yn_in0_ext_n;
assign dis_110 = yn_in2_ext_n + yn_in1_ext_n + yn_in0_ext;
assign dis_111 = yn_in2_ext_n + yn_in1_ext_n + yn_in0_ext_n;
*/

//Force metric to positive number
assign dis_000_out = dis_000 + 24;
assign dis_001_out = dis_001 + 24;
assign dis_010_out = dis_010 + 24;
assign dis_011_out = dis_011 + 24;
assign dis_100_out = dis_100 + 24;
assign dis_101_out = dis_101 + 24;
assign dis_110_out = dis_110 + 24;
assign dis_111_out = dis_111 + 24;

endmodule
