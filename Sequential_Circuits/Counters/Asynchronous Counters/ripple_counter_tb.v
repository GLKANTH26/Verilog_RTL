`include "ripple_counter.v"
module ripple_counter_tb;
	reg clk,rst;
	wire [3:0]q;
	ripple_counter asc(clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst_n=%b | q=%b",$time,clk,rst,q);
		rst=0;
		#8 rst=1;
		#160 $finish;
	end
endmodule
