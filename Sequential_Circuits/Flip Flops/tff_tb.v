`include "tff.v"
module tff_tb;
	reg t,clk,rst;
	wire q;
	tff fss(t,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b t=%b q=%b",$time,clk,rst,t,q);
		rst=0;t=1;
		#8 rst=1;
		#10 t=0;
		#10 t=0;
		#10 t=1;
		#10 t=1;
		#10 t=1;
		#10 t=0;
		#10 $finish;
	end
endmodule
