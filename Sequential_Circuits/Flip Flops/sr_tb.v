`include "sr.v"
module sr_tb;
	reg s,r,clk,rst;
	wire q;
	sr ff(s,r,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b s=%b r=%b q=%b",$time,clk,rst,s,r,q);
		rst=0;s=0;r=0;
		#8 rst=1;
		#10 s=1;r=0;
		#10 s=0;r=0;
		#10 s=0;r=1;
		#10 s=0;r=0;
		#10 s=1;r=1;
		#10 s=0;r=0;
		#10 $finish;
	end
endmodule
