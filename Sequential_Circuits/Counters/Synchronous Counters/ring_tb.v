`include "ring.v"
module ring_tb;
	localparam N=6;
	reg en,clk,rst;
	wire [N-1:0]q;
	ring#(N) r6(en,clk,rst,q);
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
		#80 $finish;
		end
endmodule
