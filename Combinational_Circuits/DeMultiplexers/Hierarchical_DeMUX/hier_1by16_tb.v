`include "hier_1by16.v"
module tb_demux1_16_hier;
	reg in;
	reg [3:0]sel;
	wire [15:0]y;
	demux1by16_hier h116(in,sel,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t in=%b sel=%b y=%h",$time,in,sel,y);
		in=1'b1;
		sel=4'b0000;
		#10 sel=4'b0101;
		#10 sel=4'b1010;
		#10 sel=4'b1111;
		#10 in=1'b0;
		#10 sel=4'b0101;
		#10 $finish;
	end
endmodule
