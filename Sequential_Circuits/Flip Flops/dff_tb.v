`include "dff.v"
module dff_tb;
	reg d,clk,rst;
	wire q;
	dff ffs(d,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b d=%b q=%b",$time,clk,rst,d,q);
		rst=0;d=1;
		#8 rst=1;
		#10 d=1;
		#10 d=0;
		#10 d=1;
		#10 $finish;
	end
endmodule
