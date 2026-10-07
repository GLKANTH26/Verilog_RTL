`include "twisted.v"
module johnson_tb;
	localparam N=4;
	reg en,clk,rst;
	wire [N-1:0]q;
	johnson#(N) tr(en,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b en=%b q=%b",$time,clk,rst,en,q);
		rst=0;en=0;
		#8 rst=1;
		#10 en=1;
		#100 $finish;
	end
endmodule
