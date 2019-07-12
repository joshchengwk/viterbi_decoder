`timescale 1ns/10ps

module conv_encoder();

reg	[5:0]	state;
integer		in_file, out_file, out_file2, i,r;
reg		in_bit;
reg		out_bit0;
reg		out_bit1;
reg		out_bit2;
reg	[3:0]	out_word0;
reg	[3:0]	out_word1;
reg	[3:0]	out_word2;


initial
begin
	in_file = $fopen("orig_msg.txt","r");
	out_file = $fopen("encode_out.dat","w");
	out_file2 = $fopen("state_out.dat", "w");
	state = 0;
	for (i=0; i<340; i=i+1) begin
		r = $fscanf(in_file, "%d", in_bit);
		out_bit0 = state[5]^state[4]^state[2]^state[1]^in_bit;
		out_bit1 = state[5]^state[3]^state[1]^state[0]^in_bit;
		out_bit2 = state[5]^state[2]^state[1]^state[0]^in_bit;
		out_word0 = (out_bit0)? 4'b1000: 4'b0111;
		out_word1 = (out_bit1)? 4'b1000: 4'b0111;
		out_word2 = (out_bit2)? 4'b1000: 4'b0111;
		$fwrite(out_file, "%4b\n%4b\n%4b\n", out_word0, out_word1, out_word2);
		$fwrite(out_file2, "%d\n", state);
		state = {state[4:0], in_bit};
	end
	$fclose(in_file);
	$fclose(out_file);
	$fclose(out_file2);
end

endmodule
	
