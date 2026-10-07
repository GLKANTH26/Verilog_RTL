`include "siso.v"
module siso_tb;
	localparam N=4;
	reg s_in,en,clk,rst;
	wire s_out;
	siso#(N) r2(s_in,en,clk,rst,s_out);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b en=%b s_in=%b s_out=%b",$time,clk,rst,en,s_in,s_out);
		rst=0;en=0;s_in=0;
		#8 rst=1;
		#10 en=1;s_in=1;
		#10 s_in=0;
		#10 s_in=1;
		#10 s_in=1;
		#10 s_in=0;
		#10 s_in=0;
		#10 $finish;
	end
endmodule
