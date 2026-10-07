`include "jk.v"
module ripple_counter(clk,rst,q);
	input clk,rst;
	output [3:0]q;
	jk tff0(1'b1,1'b1,clk,rst,q[0]);
	jk tff1(1'b1,1'b1,q[0],rst,q[1]);
	jk tff2(1'b1,1'b1,q[1],rst,q[2]);
	jk tff3(1'b1,1'b1,q[2],rst,q[3]);
endmodule
