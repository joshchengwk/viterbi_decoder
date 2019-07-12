module viterbi_tb();

parameter	clk_cycle = 100;



integer		in_file, out_file, r, count;

reg		clk;
reg		reset_n;


//BMU
reg	[3:0]	yn_in0;
reg	[3:0]	yn_in1;
reg	[3:0]	yn_in2;
wire	[5:0]	s0;
wire	[5:0]	s1;
wire	[5:0]	s2;
wire	[5:0]	s3;
wire	[5:0]	s4;
wire	[5:0]	s5;
wire	[5:0]	s6;
wire	[5:0]	s7;

//PMU
wire	[63:0]	sel_out;
wire		clk_div2_out;

//SPMU
wire	[63:0]	rdata0, rdata1, rdata2, rdata3, rdata4, rdata5;
wire	[4:0]	addr0, addr1, addr2, addr3, addr4, addr5;
wire	[63:0]	wdata;
wire	[5:0]	cs;
wire	[5:0]	we;
wire		decoded_bit_out;

//instantiate
viterbi_decoder u0(
	clk,			
	reset_n,	
	yn_in0,		
	yn_in1,	
	yn_in2,	
	decoded_bit_out, 
	wdata, 		
	rdata0, 	
	rdata1, 	
	rdata2, 	 
	rdata3,
	rdata4, 
	rdata5,  
	addr0, 
	addr1, 
	addr2,
	addr3, 
	addr4,
	addr5,
	we,	 
	cs,
	clk_div2_out
);

/*
BMU u0(
	yn_in0, 
	yn_in1,
	yn_in2,
	s0,
	s1,
	s2,
	s3,
	s4,
	s5,
	s6,
	s7
);

PMU u1(
	clk,
	reset_n,
	s0,
	s1,
	s2,
	s3,
	s4,
	s5,
	s6,
	s7,
	sel_out,
	clk_div2_out
);

SPMU u2(
	clk_div2_out,
	reset_n,
	sel_out,
	rdata0,
	rdata1,
	rdata2,
	rdata3,
	rdata4,
	rdata5,
	addr0,
	addr1,
	addr2,
	addr3,
	addr4,
	addr5,
	wdata,
	cs,
	we,
	decoded_bit_out
);
*/
sram21x64 bank0 (clk_div2_out, cs[0], we[0], addr0, wdata, rdata0);
sram21x64 bank1 (clk_div2_out, cs[1], we[1], addr1, wdata, rdata1);
sram21x64 bank2 (clk_div2_out, cs[2], we[2], addr2, wdata, rdata2);
sram21x64 bank3 (clk_div2_out, cs[3], we[3], addr3, wdata, rdata3);
sram21x64 bank4 (clk_div2_out, cs[4], we[4], addr4, wdata, rdata4);
sram21x64 bank5 (clk_div2_out, cs[5], we[5], addr5, wdata, rdata5);



//define clock
always
begin
	clk = 1;
	#(clk_cycle/2);
	clk = 0;
	#(clk_cycle/2);
end

//define reset
initial
begin
	count = 0;
	reset_n = 0;
	#256
	reset_n = 1;
end

//open file
initial
begin
	in_file = $fopen("code_symbol_soft.txt", "r");
	out_file = $fopen("decode_out.dat", "w");
	r = $fscanf(in_file, "%4b", yn_in0);
	r = $fscanf(in_file, "%4b", yn_in1);
	r = $fscanf(in_file, "%4b", yn_in2);
end

//end sim
initial
begin
	#80000;
	$fclose(in_file);
	$fclose(out_file);
	$finish;
end

//renew input

always @(posedge clk_div2_out)
begin
	r = $fscanf(in_file, "%4b", yn_in0);
	r = $fscanf(in_file, "%4b", yn_in1);
	r = $fscanf(in_file, "%4b", yn_in2);
	if(count >= 128) begin
		$fwrite(out_file, "%d\n", decoded_bit_out);
	end
	count = count + 1;
end

//write waveform
initial 
begin
	$vcdplusfile("result.vpd");
	$vcdpluson;
end

endmodule
	
module sram21x64 (clk, cs, we, addr, wdata, rdata);


input clk, cs, we; 
input [4:0] addr;
input [63:0] wdata;
output [63:0] rdata;

reg [63:0] rdata;
reg [63:0] memreg[0:20];


always @(posedge clk) 
begin
	if (!cs) begin
		rdata <= 64'bz; 
	end
	else if (we) begin
		memreg[addr] <= wdata;
		rdata <= wdata;
	end 
	else begin
		rdata <= memreg[addr];
	end
end

endmodule
	
