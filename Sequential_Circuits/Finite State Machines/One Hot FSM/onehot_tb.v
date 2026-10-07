
`include "onehot.v"
module onehot_tb;
	reg clk,in,rst;
	wire out;
	onehot dut(in,clk,rst,out);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("Time=%0t,rst=%b,in=%b,det=%b",$time,rst,in,out);
		rst=0;in=0;
		#8 rst=1;
		#10 in=1;
		#10 in=0;
		#10 in=1;
		#10 in=1;
		#10 in=0;
		#10 in=1;
		#10 $finish;
	end
endmodule
