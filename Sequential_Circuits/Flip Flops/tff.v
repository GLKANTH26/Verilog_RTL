`include "jk.v"
module tff(t,clk,rst,q);
	input t,clk,rst;
	output q;
	jk jkf(t,t,clk,rst,q);
endmodule
