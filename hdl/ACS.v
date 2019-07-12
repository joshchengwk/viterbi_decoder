//----------------------------------------------------------------
// ACS unit for viterbi decoder
// EESM518 final project
// Cheng Wai Kin
// Lo Hon Yik
//------------------------------------------------------
module ACS (
	toggle,
	pm1_in,
	pm2_in,
	bm1_in,
	bm2_in,
	pm_out,
	sel_out
);


input		toggle;
input	[10:0]	pm1_in;
input	[10:0]	pm2_in;
input	[5:0]	bm1_in;
input	[5:0]	bm2_in;
output	[10:0]	pm_out;
output		sel_out;


reg	[10:0]	pm_out;
reg		sel_out;
wire	[11:0]	diff;

wire	[10:0]	pm1;
wire	[10:0]	pm2;
wire	[5:0]	bm_mux1;
wire	[5:0]	bm_mux2;

assign bm_mux1 = (toggle)? bm2_in: bm1_in;
assign bm_mux2 = (toggle)? bm1_in: bm2_in;
assign pm1 = pm1_in + bm_mux1;
assign pm2 = pm2_in + bm_mux2;
assign diff = {1'b0, pm1} - {1'b0, pm2};

always @ (diff or pm1 or pm2) begin
	if (diff[11]) begin
		pm_out = pm1;
		sel_out = 0;
	end 
	else begin
		pm_out = pm2;
		sel_out = 1;
	end
end

endmodule
