`include "piso.v"
module piso_tb;
	localparam N=4;
	reg [N-1:0]p_in;
	reg ld,en,clk,rst;
	wire s_out;
	piso#(N) r4(p_in,ld,en,clk,rst,s_out);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b ld=%b en=%b p_in=%b s_out=%b",$time,clk,rst,ld,en,p_in,s_out);
		rst=0;ld=0;en=0;p_in=0;
		#8 rst=1;
		#10 ld=1;p_in=4'b1101;
		#10 ld=0;en=1;
		#10;
		#10;
		#10;
		#10 en=0;
		#10 $finish;
	end
endmodule
