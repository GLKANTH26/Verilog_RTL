`include "pipo.v"
module pipo_tb;
	localparam N=16;
	reg [N-1:0]d;
	reg ld,clk,rst;
	wire [N-1:0]q;
	pipo#(N) r1(d,ld,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
	$fsdbDumpvars();
	$monitor("T=%0t clk=%b rst=%b ld=%b d=%b  q=%b",$time,clk,rst,ld,d,q);
	rst=0;ld=0;d=16'hFFFF;
	#8 rst=1;
	#10 ld=1;d=16'hAA55;
	#10 ld=0;d=16'h1234;
	#10 ld=0;d=16'hC0DE;
	#10 ld=1;d=16'h0001;
	#10 $finish;
endmodule
