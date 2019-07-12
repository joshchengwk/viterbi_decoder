//--------------------------------------------
//Path metric unit for viterbi decoder
//EESM518 final project
//Cheng Wai Kin
//Lo Hon Yik
//-------------------------------------------
module PMU(
	clk,
	reset_n,
	bm_000_in,
	bm_001_in,
	bm_010_in,
	bm_011_in,
	bm_100_in,
	bm_101_in,
	bm_110_in,
	bm_111_in,
	sel_out,
	clk_div2_out
);


//-----------------------
//input/output
//-----------------------
input					clk;
input					reset_n;
input			[5:0]	bm_000_in;
input			[5:0]	bm_001_in;
input			[5:0]	bm_010_in;
input			[5:0]	bm_011_in;
input			[5:0]	bm_100_in;
input			[5:0]	bm_101_in;
input			[5:0]	bm_110_in;
input			[5:0]	bm_111_in;
output			[63:0]	sel_out;
output					clk_div2_out;

//divide 2 counter
reg						div2_count;

//clk gate signal
wire					clk_div2_gatesignal;

//path metric registers
reg				[10:0]	pathmetric00,pathmetric01,pathmetric02,pathmetric03,pathmetric04,pathmetric05,pathmetric06,pathmetric07;
reg				[10:0]	pathmetric08,pathmetric09,pathmetric10,pathmetric11,pathmetric12,pathmetric13,pathmetric14,pathmetric15;
reg				[10:0]	pathmetric16,pathmetric17,pathmetric18,pathmetric19,pathmetric20,pathmetric21,pathmetric22,pathmetric23;
reg				[10:0]	pathmetric24,pathmetric25,pathmetric26,pathmetric27,pathmetric28,pathmetric29,pathmetric30,pathmetric31;
reg				[10:0]	pathmetric32,pathmetric33,pathmetric34,pathmetric35,pathmetric36,pathmetric37,pathmetric38,pathmetric39;
reg				[10:0]	pathmetric40,pathmetric41,pathmetric42,pathmetric43,pathmetric44,pathmetric45,pathmetric46,pathmetric47;
reg				[10:0]	pathmetric48,pathmetric49,pathmetric50,pathmetric51,pathmetric52,pathmetric53,pathmetric54,pathmetric55;
reg				[10:0]	pathmetric56,pathmetric57,pathmetric58,pathmetric59,pathmetric60,pathmetric61,pathmetric62,pathmetric63;

reg				[11:0]	pm_temp00,pm_temp01,pm_temp02,pm_temp03,pm_temp04,pm_temp05,pm_temp06,pm_temp07;
reg				[11:0]	pm_temp08,pm_temp09,pm_temp10,pm_temp11,pm_temp12,pm_temp13,pm_temp14,pm_temp15;
reg				[11:0]	pm_temp16,pm_temp17,pm_temp18,pm_temp19,pm_temp20,pm_temp21,pm_temp22,pm_temp23;
reg				[11:0]	pm_temp24,pm_temp25,pm_temp26,pm_temp27,pm_temp28,pm_temp29,pm_temp30,pm_temp31; 

//ACS wires
wire			[10:0]	pm1_acs00,pm1_acs01,pm1_acs02,pm1_acs03,pm1_acs04,pm1_acs05,pm1_acs06,pm1_acs07;
wire			[10:0]	pm1_acs08,pm1_acs09,pm1_acs10,pm1_acs11,pm1_acs12,pm1_acs13,pm1_acs14,pm1_acs15;
wire			[10:0]	pm1_acs16,pm1_acs17,pm1_acs18,pm1_acs19,pm1_acs20,pm1_acs21,pm1_acs22,pm1_acs23;
wire			[10:0]	pm1_acs24,pm1_acs25,pm1_acs26,pm1_acs27,pm1_acs28,pm1_acs29,pm1_acs30,pm1_acs31;

wire			[10:0]	pm2_acs00,pm2_acs01,pm2_acs02,pm2_acs03,pm2_acs04,pm2_acs05,pm2_acs06,pm2_acs07;
wire			[10:0]	pm2_acs08,pm2_acs09,pm2_acs10,pm2_acs11,pm2_acs12,pm2_acs13,pm2_acs14,pm2_acs15;
wire			[10:0]	pm2_acs16,pm2_acs17,pm2_acs18,pm2_acs19,pm2_acs20,pm2_acs21,pm2_acs22,pm2_acs23;
wire			[10:0]	pm2_acs24,pm2_acs25,pm2_acs26,pm2_acs27,pm2_acs28,pm2_acs29,pm2_acs30,pm2_acs31;

wire			[5:0]	bm1_acs00,bm1_acs01,bm1_acs02,bm1_acs03,bm1_acs04,bm1_acs05,bm1_acs06,bm1_acs07;
wire			[5:0]	bm1_acs08,bm1_acs09,bm1_acs10,bm1_acs11,bm1_acs12,bm1_acs13,bm1_acs14,bm1_acs15;
wire			[5:0]	bm1_acs16,bm1_acs17,bm1_acs18,bm1_acs19,bm1_acs20,bm1_acs21,bm1_acs22,bm1_acs23;
wire			[5:0]	bm1_acs24,bm1_acs25,bm1_acs26,bm1_acs27,bm1_acs28,bm1_acs29,bm1_acs30,bm1_acs31;

wire			[5:0]	bm2_acs00,bm2_acs01,bm2_acs02,bm2_acs03,bm2_acs04,bm2_acs05,bm2_acs06,bm2_acs07;
wire			[5:0]	bm2_acs08,bm2_acs09,bm2_acs10,bm2_acs11,bm2_acs12,bm2_acs13,bm2_acs14,bm2_acs15;
wire			[5:0]	bm2_acs16,bm2_acs17,bm2_acs18,bm2_acs19,bm2_acs20,bm2_acs21,bm2_acs22,bm2_acs23;
wire			[5:0]	bm2_acs24,bm2_acs25,bm2_acs26,bm2_acs27,bm2_acs28,bm2_acs29,bm2_acs30,bm2_acs31;


wire			[10:0]	pm_out_acs00,pm_out_acs01,pm_out_acs02,pm_out_acs03,pm_out_acs04,pm_out_acs05,pm_out_acs06,pm_out_acs07;
wire			[10:0]	pm_out_acs08,pm_out_acs09,pm_out_acs10,pm_out_acs11,pm_out_acs12,pm_out_acs13,pm_out_acs14,pm_out_acs15;
wire			[10:0]	pm_out_acs16,pm_out_acs17,pm_out_acs18,pm_out_acs19,pm_out_acs20,pm_out_acs21,pm_out_acs22,pm_out_acs23;
wire			[10:0]	pm_out_acs24,pm_out_acs25,pm_out_acs26,pm_out_acs27,pm_out_acs28,pm_out_acs29,pm_out_acs30,pm_out_acs31;

wire 				sel_acs00,sel_acs01,sel_acs02,sel_acs03,sel_acs04,sel_acs05,sel_acs06,sel_acs07;
wire 				sel_acs08,sel_acs09,sel_acs10,sel_acs11,sel_acs12,sel_acs13,sel_acs14,sel_acs15;
wire 				sel_acs16,sel_acs17,sel_acs18,sel_acs19,sel_acs20,sel_acs21,sel_acs22,sel_acs23;
wire 				sel_acs24,sel_acs25,sel_acs26,sel_acs27,sel_acs28,sel_acs29,sel_acs30,sel_acs31;

//select temp
reg			[31:0]	sel_temp;

//divide 2 counter
always @ (posedge clk or negedge reset_n) 
begin
	if (~reset_n) 
		div2_count <= 0;
	else
		div2_count <= ~div2_count;
end

//assign div2 clock
assign clk_div2_out = ~div2_count;

//----------------------------------
//32 sets of acs
//----------------------------------
//ACS00
assign pm1_acs00 = pathmetric00;
assign pm2_acs00 = pathmetric32;
assign bm1_acs00 = bm_000_in;
assign bm2_acs00 = bm_111_in;

//ACS01
assign pm1_acs01 = pathmetric01;
assign pm2_acs01 = pathmetric33;
assign bm1_acs01 = bm_110_in;
assign bm2_acs01 = bm_001_in;

//ACS02
assign pm1_acs02 = pathmetric02;
assign pm2_acs02 = pathmetric34;
assign bm1_acs02 = bm_111_in;
assign bm2_acs02 = bm_000_in;

//ACS03
assign pm1_acs03 = pathmetric03;
assign pm2_acs03 = pathmetric35;
assign bm1_acs03 = bm_001_in;
assign bm2_acs03 = bm_110_in;

//ACS04
assign pm1_acs04 = pathmetric04;
assign pm2_acs04 = pathmetric36;
assign bm1_acs04 = bm_101_in;
assign bm2_acs04 = bm_010_in;

//ACS05
assign pm1_acs05 = pathmetric05;
assign pm2_acs05 = pathmetric37;
assign bm1_acs05 = bm_011_in;
assign bm2_acs05 = bm_100_in;

//ACS06
assign pm1_acs06 = pathmetric06;
assign pm2_acs06 = pathmetric38;
assign bm1_acs06 = bm_010_in;
assign bm2_acs06 = bm_101_in;

//ACS07
assign pm1_acs07 = pathmetric07;
assign pm2_acs07 = pathmetric39;
assign bm1_acs07 = bm_100_in;
assign bm2_acs07 = bm_011_in;

//ACS08
assign pm1_acs08 = pathmetric08;
assign pm2_acs08 = pathmetric40;
assign bm1_acs08 = bm_010_in;
assign bm2_acs08 = bm_101_in;

//ACS09
assign pm1_acs09 = pathmetric09;
assign pm2_acs09 = pathmetric41;
assign bm1_acs09 = bm_100_in;
assign bm2_acs09 = bm_011_in;

//ACS10
assign pm1_acs10 = pathmetric10;
assign pm2_acs10 = pathmetric42;
assign bm1_acs10 = bm_101_in;
assign bm2_acs10 = bm_010_in;

//ACS11
assign pm1_acs11 = pathmetric11;
assign pm2_acs11 = pathmetric43;
assign bm1_acs11 = bm_011_in;
assign bm2_acs11 = bm_100_in;

//ACS12
assign pm1_acs12 = pathmetric12;
assign pm2_acs12 = pathmetric44;
assign bm1_acs12 = bm_111_in;
assign bm2_acs12 = bm_000_in;

//ACS13
assign pm1_acs13 = pathmetric13;
assign pm2_acs13 = pathmetric45;
assign bm1_acs13 = bm_001_in;
assign bm2_acs13 = bm_110_in;

//ACS14
assign pm1_acs14 = pathmetric14;
assign pm2_acs14 = pathmetric46;
assign bm1_acs14 = bm_000_in;
assign bm2_acs14 = bm_111_in;

//ACS15
assign pm1_acs15 = pathmetric15;
assign pm2_acs15 = pathmetric47;
assign bm1_acs15 = bm_110_in;
assign bm2_acs15 = bm_001_in;

//ACS16
assign pm1_acs16 = pathmetric16;
assign pm2_acs16 = pathmetric48;
assign bm1_acs16 = bm_001_in;
assign bm2_acs16 = bm_110_in;

//ACS17
assign pm1_acs17 = pathmetric17;
assign pm2_acs17 = pathmetric49;
assign bm1_acs17 = bm_111_in;
assign bm2_acs17 = bm_000_in;

//ACS18
assign pm1_acs18 = pathmetric18;
assign pm2_acs18 = pathmetric50;
assign bm1_acs18 = bm_110_in;
assign bm2_acs18 = bm_001_in;

//ACS19
assign pm1_acs19 = pathmetric19;
assign pm2_acs19 = pathmetric51;
assign bm1_acs19 = bm_000_in;
assign bm2_acs19 = bm_111_in;

//ACS20
assign pm1_acs20 = pathmetric20;
assign pm2_acs20 = pathmetric52;
assign bm1_acs20 = bm_100_in;
assign bm2_acs20 = bm_011_in;

//ACS21
assign pm1_acs21 = pathmetric21;
assign pm2_acs21 = pathmetric53;
assign bm1_acs21 = bm_010_in;
assign bm2_acs21 = bm_101_in;

//ACS22
assign pm1_acs22 = pathmetric22;
assign pm2_acs22 = pathmetric54;
assign bm1_acs22 = bm_011_in;
assign bm2_acs22 = bm_100_in;
 
//ACS23
assign pm1_acs23 = pathmetric23;
assign pm2_acs23 = pathmetric55;
assign bm1_acs23 = bm_101_in;
assign bm2_acs23 = bm_010_in;

//ACS24
assign pm1_acs24 = pathmetric24;
assign pm2_acs24 = pathmetric56;
assign bm1_acs24 = bm_011_in;
assign bm2_acs24 = bm_100_in;

//ACS25
assign pm1_acs25 = pathmetric25;
assign pm2_acs25 = pathmetric57;
assign bm1_acs25 = bm_101_in;
assign bm2_acs25 = bm_010_in;

//ACS26
assign pm1_acs26 = pathmetric26;
assign pm2_acs26 = pathmetric58;
assign bm1_acs26 = bm_100_in;
assign bm2_acs26 = bm_011_in;
 
//ACS27
assign pm1_acs27 = pathmetric27;
assign pm2_acs27 = pathmetric59;
assign bm1_acs27 = bm_010_in;
assign bm2_acs27 = bm_101_in;
 
//ACS28
assign pm1_acs28 = pathmetric28;
assign pm2_acs28 = pathmetric60;
assign bm1_acs28 = bm_110_in;
assign bm2_acs28 = bm_001_in;

//ACS29
assign pm1_acs29 = pathmetric29;
assign pm2_acs29 = pathmetric61;
assign bm1_acs29 = bm_000_in;
assign bm2_acs29 = bm_111_in;

//ACS30
assign pm1_acs30 = pathmetric30;
assign pm2_acs30 = pathmetric62;
assign bm1_acs30 = bm_001_in;
assign bm2_acs30 = bm_110_in;

//ACS31
assign pm1_acs31 = pathmetric31;
assign pm2_acs31 = pathmetric63;
assign bm1_acs31 = bm_111_in;
assign bm2_acs31 = bm_000_in;


reg [63:0] sel;

// store path metrics
always @ (posedge clk or negedge reset_n)
begin
	if (~reset_n) begin
		pm_temp00 <= 0;
		pm_temp01 <= 0;
		pm_temp02 <= 0;
		pm_temp03 <= 0;
		pm_temp04 <= 0;
		pm_temp05 <= 0;
		pm_temp06 <= 0;
		pm_temp07 <= 0;
		pm_temp08 <= 0;
		pm_temp09 <= 0;
		pm_temp10 <= 0;
		pm_temp11 <= 0;
		pm_temp12 <= 0;
		pm_temp13 <= 0;
		pm_temp14 <= 0;
		pm_temp15 <= 0;
		pm_temp16 <= 0;
		pm_temp17 <= 0;
		pm_temp18 <= 0;
		pm_temp19 <= 0;
		pm_temp20 <= 0;
		pm_temp21 <= 0;
		pm_temp22 <= 0;
		pm_temp23 <= 0;
		pm_temp24 <= 0;
		pm_temp25 <= 0;
		pm_temp26 <= 0;
		pm_temp27 <= 0;
		pm_temp28 <= 0;
		pm_temp29 <= 0;
		pm_temp30 <= 0;
		pm_temp31 <= 0;
		pathmetric00 <= 0;
		pathmetric01 <= 0;
		pathmetric02 <= 0;
		pathmetric03 <= 0;
		pathmetric04 <= 0;
		pathmetric05 <= 0;
		pathmetric06 <= 0;
		pathmetric07 <= 0;
		pathmetric08 <= 0;
		pathmetric09 <= 0;
		pathmetric10 <= 0;
		pathmetric11 <= 0;
		pathmetric12 <= 0;
		pathmetric13 <= 0;
		pathmetric14 <= 0;
		pathmetric15 <= 0;
		pathmetric16 <= 0;
		pathmetric17 <= 0;
		pathmetric18 <= 0;
		pathmetric19 <= 0;
		pathmetric20 <= 0;
		pathmetric21 <= 0;
		pathmetric22 <= 0;
		pathmetric23 <= 0;
		pathmetric24 <= 0;
		pathmetric25 <= 0;
		pathmetric26 <= 0;
		pathmetric27 <= 0;
		pathmetric28 <= 0;
		pathmetric29 <= 0;
		pathmetric30 <= 0;
		pathmetric31 <= 0;
		pathmetric32 <= 0;
		pathmetric33 <= 0;
		pathmetric34 <= 0;
		pathmetric35 <= 0;
		pathmetric36 <= 0;
		pathmetric37 <= 0;
		pathmetric38 <= 0;
		pathmetric39 <= 0;
		pathmetric40 <= 0;
		pathmetric41 <= 0;
		pathmetric42 <= 0;
		pathmetric43 <= 0;
		pathmetric44 <= 0;
		pathmetric45 <= 0;
		pathmetric46 <= 0;
		pathmetric47 <= 0;
		pathmetric48 <= 0;
		pathmetric49 <= 0;
		pathmetric50 <= 0;
		pathmetric51 <= 0;
		pathmetric52 <= 0;
		pathmetric53 <= 0;
		pathmetric54 <= 0;
		pathmetric55 <= 0;
		pathmetric56 <= 0;
		pathmetric57 <= 0;
		pathmetric58 <= 0;
		pathmetric59 <= 0;
		pathmetric60 <= 0;
		pathmetric61 <= 0;
		pathmetric62 <= 0;
		pathmetric63 <= 0;
		sel_temp <= 0;
	end 
	else if (~div2_count) begin
		pm_temp00 <= pm_out_acs00;
		pm_temp01 <= pm_out_acs01;
		pm_temp02 <= pm_out_acs02;
		pm_temp03 <= pm_out_acs03;
		pm_temp04 <= pm_out_acs04;
		pm_temp05 <= pm_out_acs05;
		pm_temp06 <= pm_out_acs06;
		pm_temp07 <= pm_out_acs07;
		pm_temp08 <= pm_out_acs08;
		pm_temp09 <= pm_out_acs09;
		pm_temp10 <= pm_out_acs10;
		pm_temp11 <= pm_out_acs11;
		pm_temp12 <= pm_out_acs12;
		pm_temp13 <= pm_out_acs13;
		pm_temp14 <= pm_out_acs14;
		pm_temp15 <= pm_out_acs15;
		pm_temp16 <= pm_out_acs16;
		pm_temp17 <= pm_out_acs17;
		pm_temp18 <= pm_out_acs18;
		pm_temp19 <= pm_out_acs19;
		pm_temp20 <= pm_out_acs20;
		pm_temp21 <= pm_out_acs21;
		pm_temp22 <= pm_out_acs22;
		pm_temp23 <= pm_out_acs23;
		pm_temp24 <= pm_out_acs24;
		pm_temp25 <= pm_out_acs25;
		pm_temp26 <= pm_out_acs26;
		pm_temp27 <= pm_out_acs27;
		pm_temp28 <= pm_out_acs28;
		pm_temp29 <= pm_out_acs29;
		pm_temp30 <= pm_out_acs30;
		pm_temp31 <= pm_out_acs31;
		sel_temp[0]  <= sel_acs00;
		sel_temp[1]  <= sel_acs01;
		sel_temp[2]  <= sel_acs02;
		sel_temp[3]  <= sel_acs03;
		sel_temp[4]  <= sel_acs04;
		sel_temp[5]  <= sel_acs05;
		sel_temp[6]  <= sel_acs06;
		sel_temp[7]  <= sel_acs07;
		sel_temp[8]  <= sel_acs08;
		sel_temp[9]  <= sel_acs09;
		sel_temp[10] <= sel_acs10;
		sel_temp[11] <= sel_acs11;
		sel_temp[12] <= sel_acs12;
		sel_temp[13] <= sel_acs13;
		sel_temp[14] <= sel_acs14;
		sel_temp[15] <= sel_acs15;
		sel_temp[16] <= sel_acs16;
		sel_temp[17] <= sel_acs17;
		sel_temp[18] <= sel_acs18;
		sel_temp[19] <= sel_acs19;
		sel_temp[20] <= sel_acs20;
		sel_temp[21] <= sel_acs21;
		sel_temp[22] <= sel_acs22;
		sel_temp[23] <= sel_acs23;
		sel_temp[24] <= sel_acs24;
		sel_temp[25] <= sel_acs25;
		sel_temp[26] <= sel_acs26;
		sel_temp[27] <= sel_acs27;
		sel_temp[28] <= sel_acs28;
		sel_temp[29] <= sel_acs29;
		sel_temp[30] <= sel_acs30;
		sel_temp[31] <= sel_acs31;
	end
	else begin
		pathmetric00 <= pm_temp00;
		pathmetric02 <= pm_temp01;
		pathmetric04 <= pm_temp02;
		pathmetric06 <= pm_temp03;
		pathmetric08 <= pm_temp04;
		pathmetric10 <= pm_temp05;
		pathmetric12 <= pm_temp06;
		pathmetric14 <= pm_temp07;
		pathmetric16 <= pm_temp08;
		pathmetric18 <= pm_temp09;
		pathmetric20 <= pm_temp10;
		pathmetric22 <= pm_temp11;
		pathmetric24 <= pm_temp12;
		pathmetric26 <= pm_temp13;
		pathmetric28 <= pm_temp14;
		pathmetric30 <= pm_temp15;
		pathmetric32 <= pm_temp16;
		pathmetric34 <= pm_temp17;
		pathmetric36 <= pm_temp18;
		pathmetric38 <= pm_temp19;
		pathmetric40 <= pm_temp20;
		pathmetric42 <= pm_temp21;
		pathmetric44 <= pm_temp22;
		pathmetric46 <= pm_temp23;
		pathmetric48 <= pm_temp24;
		pathmetric50 <= pm_temp25;
		pathmetric52 <= pm_temp26;
		pathmetric54 <= pm_temp27;
		pathmetric56 <= pm_temp28;
		pathmetric58 <= pm_temp29;
		pathmetric60 <= pm_temp30;
		pathmetric62 <= pm_temp31;
		
		pathmetric01 <= pm_out_acs00;
		pathmetric03 <= pm_out_acs01;
		pathmetric05 <= pm_out_acs02;
		pathmetric07 <= pm_out_acs03;
		pathmetric09 <= pm_out_acs04;
		pathmetric11 <= pm_out_acs05;
		pathmetric13 <= pm_out_acs06;
		pathmetric15 <= pm_out_acs07;
		pathmetric17 <= pm_out_acs08;
		pathmetric19 <= pm_out_acs09;
		pathmetric21 <= pm_out_acs10;
		pathmetric23 <= pm_out_acs11;
		pathmetric25 <= pm_out_acs12;
		pathmetric27 <= pm_out_acs13;
		pathmetric29 <= pm_out_acs14;
		pathmetric31 <= pm_out_acs15;
		pathmetric33 <= pm_out_acs16;
		pathmetric35 <= pm_out_acs17;
		pathmetric37 <= pm_out_acs18;
		pathmetric39 <= pm_out_acs19;
		pathmetric41 <= pm_out_acs20;
		pathmetric43 <= pm_out_acs21;
		pathmetric45 <= pm_out_acs22;
		pathmetric47 <= pm_out_acs23;
		pathmetric49 <= pm_out_acs24;
		pathmetric51 <= pm_out_acs25;
		pathmetric53 <= pm_out_acs26;
		pathmetric55 <= pm_out_acs27;
		pathmetric57 <= pm_out_acs28;
		pathmetric59 <= pm_out_acs29;
		pathmetric61 <= pm_out_acs30;
		pathmetric63 <= pm_out_acs31;
	end
end	


reg [63:0] sel_out;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		sel_out <= 0;
	end 
	else begin
		if (div2_count) begin
			sel_out[0]  <= sel_temp[0];
			sel_out[2]  <= sel_temp[1];
			sel_out[4]  <= sel_temp[2];
			sel_out[6]  <= sel_temp[3];
			sel_out[8]  <= sel_temp[4];
			sel_out[10] <= sel_temp[5];
			sel_out[12] <= sel_temp[6];
			sel_out[14] <= sel_temp[7];
			sel_out[16] <= sel_temp[8];
			sel_out[18] <= sel_temp[9];
			sel_out[20] <= sel_temp[10];
			sel_out[22] <= sel_temp[11];
			sel_out[24] <= sel_temp[12];
			sel_out[26] <= sel_temp[13];
			sel_out[28] <= sel_temp[14];
			sel_out[30] <= sel_temp[15];
			sel_out[32] <= sel_temp[16];
			sel_out[34] <= sel_temp[17];
			sel_out[36] <= sel_temp[18];
			sel_out[38] <= sel_temp[19];
			sel_out[40] <= sel_temp[20];
			sel_out[42] <= sel_temp[21];
			sel_out[44] <= sel_temp[22];
			sel_out[46] <= sel_temp[23];
			sel_out[48] <= sel_temp[24];
			sel_out[50] <= sel_temp[25];
			sel_out[52] <= sel_temp[26];
			sel_out[54] <= sel_temp[27];
			sel_out[56] <= sel_temp[28];
			sel_out[58] <= sel_temp[29];
			sel_out[60] <= sel_temp[30];
			sel_out[62] <= sel_temp[31];

			sel_out[1]  <= sel_acs00;
			sel_out[3]  <= sel_acs01;
			sel_out[5]  <= sel_acs02;
			sel_out[7]  <= sel_acs03;
			sel_out[9]  <= sel_acs04;
			sel_out[11] <= sel_acs05;
			sel_out[13] <= sel_acs06;
			sel_out[15] <= sel_acs07;
			sel_out[17] <= sel_acs08;
			sel_out[19] <= sel_acs09;
			sel_out[21] <= sel_acs10;
			sel_out[23] <= sel_acs11;
			sel_out[25] <= sel_acs12;
			sel_out[27] <= sel_acs13;
			sel_out[29] <= sel_acs14;
			sel_out[31] <= sel_acs15;
			sel_out[33] <= sel_acs16;
			sel_out[35] <= sel_acs17;
			sel_out[37] <= sel_acs18;
			sel_out[39] <= sel_acs19;
			sel_out[41] <= sel_acs20;
			sel_out[43] <= sel_acs21;
			sel_out[45] <= sel_acs22;
			sel_out[47] <= sel_acs23;
			sel_out[49] <= sel_acs24;
			sel_out[51] <= sel_acs25;
			sel_out[53] <= sel_acs26;
			sel_out[55] <= sel_acs27;
			sel_out[57] <= sel_acs28;
			sel_out[59] <= sel_acs29;
			sel_out[61] <= sel_acs30;
			sel_out[63] <= sel_acs31;
		end
	end
end

// instantiate 32 sets of acs
ACS acs00 (div2_count,pm1_acs00,pm2_acs00,bm1_acs00,bm2_acs00,pm_out_acs00,sel_acs00);
ACS acs01 (div2_count,pm1_acs01,pm2_acs01,bm1_acs01,bm2_acs01,pm_out_acs01,sel_acs01);
ACS acs02 (div2_count,pm1_acs02,pm2_acs02,bm1_acs02,bm2_acs02,pm_out_acs02,sel_acs02);
ACS acs03 (div2_count,pm1_acs03,pm2_acs03,bm1_acs03,bm2_acs03,pm_out_acs03,sel_acs03);
ACS acs04 (div2_count,pm1_acs04,pm2_acs04,bm1_acs04,bm2_acs04,pm_out_acs04,sel_acs04);
ACS acs05 (div2_count,pm1_acs05,pm2_acs05,bm1_acs05,bm2_acs05,pm_out_acs05,sel_acs05);
ACS acs06 (div2_count,pm1_acs06,pm2_acs06,bm1_acs06,bm2_acs06,pm_out_acs06,sel_acs06);
ACS acs07 (div2_count,pm1_acs07,pm2_acs07,bm1_acs07,bm2_acs07,pm_out_acs07,sel_acs07);
ACS acs08 (div2_count,pm1_acs08,pm2_acs08,bm1_acs08,bm2_acs08,pm_out_acs08,sel_acs08);
ACS acs09 (div2_count,pm1_acs09,pm2_acs09,bm1_acs09,bm2_acs09,pm_out_acs09,sel_acs09);
ACS acs10 (div2_count,pm1_acs10,pm2_acs10,bm1_acs10,bm2_acs10,pm_out_acs10,sel_acs10);
ACS acs11 (div2_count,pm1_acs11,pm2_acs11,bm1_acs11,bm2_acs11,pm_out_acs11,sel_acs11);
ACS acs12 (div2_count,pm1_acs12,pm2_acs12,bm1_acs12,bm2_acs12,pm_out_acs12,sel_acs12);
ACS acs13 (div2_count,pm1_acs13,pm2_acs13,bm1_acs13,bm2_acs13,pm_out_acs13,sel_acs13);
ACS acs14 (div2_count,pm1_acs14,pm2_acs14,bm1_acs14,bm2_acs14,pm_out_acs14,sel_acs14);
ACS acs15 (div2_count,pm1_acs15,pm2_acs15,bm1_acs15,bm2_acs15,pm_out_acs15,sel_acs15);
ACS acs16 (div2_count,pm1_acs16,pm2_acs16,bm1_acs16,bm2_acs16,pm_out_acs16,sel_acs16);
ACS acs17 (div2_count,pm1_acs17,pm2_acs17,bm1_acs17,bm2_acs17,pm_out_acs17,sel_acs17);
ACS acs18 (div2_count,pm1_acs18,pm2_acs18,bm1_acs18,bm2_acs18,pm_out_acs18,sel_acs18);
ACS acs19 (div2_count,pm1_acs19,pm2_acs19,bm1_acs19,bm2_acs19,pm_out_acs19,sel_acs19);
ACS acs20 (div2_count,pm1_acs20,pm2_acs20,bm1_acs20,bm2_acs20,pm_out_acs20,sel_acs20);
ACS acs21 (div2_count,pm1_acs21,pm2_acs21,bm1_acs21,bm2_acs21,pm_out_acs21,sel_acs21);
ACS acs22 (div2_count,pm1_acs22,pm2_acs22,bm1_acs22,bm2_acs22,pm_out_acs22,sel_acs22);
ACS acs23 (div2_count,pm1_acs23,pm2_acs23,bm1_acs23,bm2_acs23,pm_out_acs23,sel_acs23);
ACS acs24 (div2_count,pm1_acs24,pm2_acs24,bm1_acs24,bm2_acs24,pm_out_acs24,sel_acs24);
ACS acs25 (div2_count,pm1_acs25,pm2_acs25,bm1_acs25,bm2_acs25,pm_out_acs25,sel_acs25);
ACS acs26 (div2_count,pm1_acs26,pm2_acs26,bm1_acs26,bm2_acs26,pm_out_acs26,sel_acs26);
ACS acs27 (div2_count,pm1_acs27,pm2_acs27,bm1_acs27,bm2_acs27,pm_out_acs27,sel_acs27);
ACS acs28 (div2_count,pm1_acs28,pm2_acs28,bm1_acs28,bm2_acs28,pm_out_acs28,sel_acs28);
ACS acs29 (div2_count,pm1_acs29,pm2_acs29,bm1_acs29,bm2_acs29,pm_out_acs29,sel_acs29);
ACS acs30 (div2_count,pm1_acs30,pm2_acs30,bm1_acs30,bm2_acs30,pm_out_acs30,sel_acs30);
ACS acs31 (div2_count,pm1_acs31,pm2_acs31,bm1_acs31,bm2_acs31,pm_out_acs31,sel_acs31);

endmodule
