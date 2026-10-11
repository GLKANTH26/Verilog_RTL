`include "jk.v"
module jk_tb;
	reg j,k,clk,rst;
	wire q;
	jk ff(j,k,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b j=%b k=%b q=%b",$time,clk,rst,j,k,q);
		rst=0;j=0;k=0;
		#8 rst=1;
		#10 j=1;k=0;
		#10 j=0;k=0;
		#10 j=0;k=1;
		#10 j=0;k=0;
		#10 j=1;k=1;
		#10 j=1;k=1;
		#10 j=1;k=1;
		#10 $finish;
	end
endmodule
