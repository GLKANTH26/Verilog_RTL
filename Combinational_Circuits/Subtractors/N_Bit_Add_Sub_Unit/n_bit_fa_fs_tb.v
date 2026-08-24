`include "n_bit_fa_fs.v"
module n_bit_fa_fs_tb;
	localparam N=16;
	reg [N-1:0] a,b;
	reg cin,x;
	wire [N-1:0] sum_diff;
	wire c_out;
	nbit_fa_fs#(N) dut(a,b,cin,x,sum_diff,c_out);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t Control=%b c_in=%b a=%d b=%d sum/Diff=%d cout/bor=%b", $time,x,cin,a,b,sum_diff,c_out);
		a = 16'h0005; b = 16'h0003; cin = 1'b0; x = 1'b0;
		#10;
		a = 16'd100; b = 16'd200; cin = 1'b0; x = 1'b0;
		#10;
		a = 16'hFFFF; b = 16'h0001; cin = 1'b0; x = 1'b0;
		#10;
		a = 16'd10; b = 16'd7; cin = 1'b0; x = 1'b1;
		#10;
		a = 16'd5; b = 16'd8; cin = 1'b0; x = 1'b1;
		#10;
		a = 16'h0000; b = 16'h0001; cin = 1'b0; x = 1'b1;
		#10;
		$finish;
	end
endmodule

