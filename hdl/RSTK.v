//---------------------------------
// Reverse Stack for viterbi decoder
// EESM518 final project
// Cheng Wai Kin
// Lo Hon Yik
//---------------------------------
module RSTK(
		clk,
		reset_n,
		stack_toggle,
		decode_in,
		reverse_out);

input		clk;
input		reset_n;
input		stack_toggle;
input		decode_in;
output		reverse_out;


reg [20:0] stack0;
reg [20:0] stack1;
reg reverse_out;

always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		stack0 <= 0;
		stack1 <= 0;
		reverse_out <= 0;
	end else begin
		if (stack_toggle) begin
			stack0 <= {stack0[19:0],decode_in};
			stack1 <= {1'b0,stack1[20:1]};
			reverse_out <= stack1[0];
		end 
		else begin
			stack1 <= {stack1[19:0],decode_in};
			stack0 <= {1'b0,stack0[20:1]};
			reverse_out <= stack0[0];
		end
	end
end

endmodule