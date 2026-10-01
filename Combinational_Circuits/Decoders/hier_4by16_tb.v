`include "hier_4by16.v"
module hier_4by16_tb;
	reg [3:0]in;
	reg en;
	wire [15:0]y;
	decoder4by16_hier h11624(in,en,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t en=%b in=%b y=%h",$time,en,in,y);
		en=1'b1;
		in=4'b0000;
		#10 in=4'b0101;
		#10 in=4'b1010;
		#10 in=4'b1111;
		#10 en=1'b0;
		#10 in=4'b0101;
		#10 $finish;
	end
endmodule
