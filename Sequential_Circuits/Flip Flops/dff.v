`include "jk.v"
module dff(d,clk,rst,q);
	input d,clk,rst;
	output q;
	wire k;
	not i1(k,d);
	jk ff(d,k,clk,rst,q);
endmodule
