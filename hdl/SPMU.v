//------------------------------------------------------
// 3-pointer Algorithm survivor path memory management
// for viterbi decoder
// EESM518 final project
// Cheng Wai kin
// Lo Hon Yik
//------------------------------------------------------
module SPMU(
	clk,
	reset_n,
	sel_in,
	rdata0_in,
	rdata1_in,
	rdata2_in,
	rdata3_in,
	rdata4_in,
	rdata5_in,
	addr0_out,
	addr1_out,
	addr2_out,
	addr3_out,
	addr4_out,
	addr5_out,
	wdata_out,
	cs_out,
	we_out,
	reverse_decoded_bit,
	stack_toggle
);

input clk;
input reset_n;
input [63:0] sel_in;
input [63:0] rdata0_in,rdata1_in,rdata2_in,rdata3_in,rdata4_in,rdata5_in;
output [4:0] addr0_out,addr1_out,addr2_out,addr3_out,addr4_out,addr5_out;
output [63:0] wdata_out;
output [5:0] cs_out;
output [5:0] we_out;
//output decoded_bit_out;
output		reverse_decoded_bit;
output		stack_toggle;

reg [4:0] addr0;
reg [4:0] addr1;
reg [4:0] addr2;
reg [4:0] addr3;
reg [4:0] addr4;
reg [4:0] addr5;
reg [5:0] cs;
reg [5:0] we;

assign addr0_out = addr0;
assign addr1_out = addr1;
assign addr2_out = addr2;
assign addr3_out = addr3;
assign addr4_out = addr4;
assign addr5_out = addr5;
assign wdata_out = sel_in;
assign cs_out = cs;
assign we_out = we;


// mod21 counter
reg [4:0] mod21_count;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		mod21_count <= 0;
	end else begin
		if (mod21_count==20) begin
			mod21_count <= 0;
		end else begin
			mod21_count <= mod21_count + 1;
		end
	end
end

wire [4:0] mod21_count_minus;
assign mod21_count_minus = 20 - mod21_count;

// 6 bank time period
reg [2:0] bank_state;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		bank_state <= 0;
	end else begin
		case (bank_state)
			3'b000: begin
				if (mod21_count==20) begin
					bank_state <= 3'b001;
				end				
			end
			3'b001: begin
				if (mod21_count==20) begin
					bank_state <= 3'b010;
				end				
			end
			3'b010: begin
				if (mod21_count==20) begin
					bank_state <= 3'b011;
				end				
			end
			3'b011: begin
				if (mod21_count==20) begin
					bank_state <= 3'b100;
				end				
			end
			3'b100: begin
				if (mod21_count==20) begin
					bank_state <= 3'b101;
				end				
			end
			3'b101: begin
				if (mod21_count==20) begin
					bank_state <= 3'b000;
				end				
			end
			default: begin
				bank_state <= 3'b000;
			end
		endcase
	end
end

// bank memory signals
reg [2:0] tb0;
reg [2:0] tb1;
reg [2:0] dc;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		cs <= 6'b000000;
		we <= 6'b000000;
		addr0 <= 0;
		addr1 <= 0;
		addr2 <= 0;
		addr3 <= 0;
		addr4 <= 0;
		addr5 <= 0;
		tb0 <= 5;
		tb1 <= 3;
		dc <= 1;
	end else begin
		case (bank_state)
			3'b000: begin
				cs <= 6'b101011;
				we <= 6'b000001;
				addr0 <= mod21_count;					
				addr1 <= mod21_count_minus;		// dc
				addr2 <= 0;
				addr3 <= mod21_count_minus;		
				addr4 <= 0;
				addr5 <= mod21_count_minus;		
				tb0 <= 5;
				tb1 <= 3;
				dc <= 1;
			end
			3'b001: begin
				cs <= 6'b010111;
				we <= 6'b000010;
				addr0 <= mod21_count_minus;		
				addr1 <= mod21_count;					
				addr2 <= mod21_count_minus;		// dc
				addr3 <= 0;
				addr4 <= mod21_count_minus;
				addr5 <= 0;
				tb0 <= 0;
				tb1 <= 4;
				dc <= 2;
			end
			3'b010: begin
				cs <= 6'b101110;
				we <= 6'b000100;		
				addr0 <= 0;
				addr1 <= mod21_count_minus;
				addr2 <= mod21_count;
				addr3 <= mod21_count_minus;		// dc
				addr4 <= 0;
				addr5 <= mod21_count_minus;
				tb0 <= 1;
				tb1 <= 5;
				dc <= 3;
			end
			3'b011: begin
				cs <= 6'b011101;
				we <= 6'b001000;			
				addr0 <= mod21_count_minus;
				addr1 <= 0;
				addr2 <= mod21_count_minus;
				addr3 <= mod21_count;
				addr4 <= mod21_count_minus;		// dc
				addr5 <= 0;
				tb0 <= 2;
				tb1 <= 0;
				dc <= 4;
			end
			3'b100: begin
				cs <= 6'b111010;
				we <= 6'b010000;		
				addr0 <= 0;
				addr1 <= mod21_count_minus;
				addr2 <= 0;
				addr3 <= mod21_count_minus;
				addr4 <= mod21_count;
				addr5 <= mod21_count_minus;		// dc
				tb0 <= 3;
				tb1 <= 1;
				dc <= 5;
			end
			3'b101: begin
				cs <= 6'b110101;
				we <= 6'b100000;			
				addr0 <= mod21_count_minus;		// dc
				addr1 <= 0;
				addr2 <= mod21_count_minus;
				addr3 <= 0;
				addr4 <= mod21_count_minus;
				addr5 <= mod21_count;
				tb0 <= 4;
				tb1 <= 2;
				dc <= 0;
			end
			default: begin
				cs <= 6'b000000;
				we <= 6'b000000;
				addr0 <= 0;
				addr1 <= 0;
				addr2 <= 0;
				addr3 <= 0;
				addr4 <= 0;
				addr5 <= 0;
				tb0 <= 5;
				tb1 <= 3;
				dc <= 1;
			end
		endcase
	end
end

reg [2:0] tb0_delay;
reg [2:0] tb1_delay;

always @(posedge clk or negedge reset_n)
begin
	if (~reset_n) begin
		tb0_delay <= 0;
		tb1_delay <= 0;
	end
	else begin
		tb0_delay <= tb0;
		tb1_delay <= tb1;
	end
end

reg [63:0] rdata_tb0;
always @ (tb0_delay or rdata0_in or rdata1_in or rdata2_in or rdata3_in or rdata4_in or rdata5_in) begin
	case (tb0_delay)
		3'b000: rdata_tb0 = rdata0_in;
		3'b001: rdata_tb0 = rdata1_in;
		3'b010: rdata_tb0 = rdata2_in;
		3'b011: rdata_tb0 = rdata3_in;
		3'b100: rdata_tb0 = rdata4_in;
		3'b101: rdata_tb0 = rdata5_in;
		default: rdata_tb0 = 0;
	endcase
end

reg [63:0] rdata_tb1;
always @ (tb1_delay or rdata0_in or rdata1_in or rdata2_in or rdata3_in or rdata4_in or rdata5_in) begin
	case (tb1_delay)
		3'b000: rdata_tb1 = rdata0_in;
		3'b001: rdata_tb1 = rdata1_in;
		3'b010: rdata_tb1 = rdata2_in;
		3'b011: rdata_tb1 = rdata3_in;
		3'b100: rdata_tb1 = rdata4_in;
		3'b101: rdata_tb1 = rdata5_in;
		default: rdata_tb1 = 0;
	endcase
end

reg [63:0] rdata_dc;
always @ (dc or rdata0_in or rdata1_in or rdata2_in or rdata3_in or rdata4_in or rdata5_in) begin
	case (dc)
		3'b000: rdata_dc = rdata0_in;
		3'b001: rdata_dc = rdata1_in;
		3'b010: rdata_dc = rdata2_in;
		3'b011: rdata_dc = rdata3_in;
		3'b100: rdata_dc = rdata4_in;
		3'b101: rdata_dc = rdata5_in;
		default: rdata_dc = 0;
	endcase
end

reg [4:0] mod21_count_delay;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		mod21_count_delay <= 0;
	end else begin
		mod21_count_delay <= mod21_count;
	end
end

reg [5:0] tb0_state;
wire tb0_bit;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		tb0_state <= 0;
	end else begin
		if (mod21_count_delay==0) begin
			tb0_state <= 0;
		end else begin
			tb0_state <= {tb0_bit, tb0_state[5:1]};
		end
	end
end
assign tb0_bit = rdata_tb0[tb0_state];


reg [5:0] tb1_state;
wire tb1_bit;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		tb1_state <= 0;
	end else begin
		if (mod21_count_delay==0) begin
			tb1_state <= {tb0_bit, tb0_state[5:1]};
		end else begin
			tb1_state <= {tb1_bit, tb1_state[5:1]};
		end
	end
end
assign tb1_bit = rdata_tb1[tb1_state];

reg [5:0] dc_state;
wire dc_bit;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		dc_state <= 0;
	end else begin
		if (mod21_count_delay==0) begin
			dc_state <= {tb1_bit, tb1_state[5:1]};
		end else begin
			dc_state <= {dc_bit, dc_state[5:1]};
		end
	end
end
assign dc_bit = rdata_dc[dc_state];

//Stack control
reg stack_toggle;
always @ (posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		stack_toggle <= 0;
	end else begin
		if (mod21_count_delay==0) begin
			stack_toggle <= ~stack_toggle;
		end
	end
end

wire reverse_decoded_bit;
assign reverse_decoded_bit = dc_state[0];


endmodule