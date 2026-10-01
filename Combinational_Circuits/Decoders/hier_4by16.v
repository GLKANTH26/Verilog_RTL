`include "2by4.v"
module decoder4by16_hier(in,en,y);
	input [3:0]in;
	input en;
	output [15:0]y;
	wire [3:0]w_en;
	decoder2by4 d1(in[3:2],en,w_en);
	decoder2by4 d2(in[1:0],w_en[0],y[3:0]);
	decoder2by4 d3(in[1:0],w_en[1],y[7:4]);
	decoder2by4 d4(in[1:0],w_en[2],y[11:8]);
	decoder2by4 d5(in[1:0],w_en[3],y[15:12]);
endmodule
