`include "hier_8by3.v"
module hier_8by3_tb;
	reg [7:0]in;
	reg en;
	wire [2:0]y;
	wire valid;
	hier_8by3 prenc83(in,en,y,valid);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t en=%b in=%b valid=%b y=%b(%d)",$time,en,in,valid,y,y);
		en=1'b1;
		in=8'h01;
		#10 in=8'h10;
		#10 in=8'h18;
		#10 in=8'h00;
		#10 en=1'b0;
		#10 in=8'h80;
		#10 $finish;
	end
endmodule
