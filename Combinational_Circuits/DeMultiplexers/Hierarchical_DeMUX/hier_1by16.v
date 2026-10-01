`include "1by4.v"
module demux1by16_hier(in,sel,y);
	input in;
	input [3:0]sel;
	output [15:0]y;
	wire [3:0]w;
	demux4 m1(in,sel[3:2],w);
	demux4 m2(w[0],sel[1:0],y[3:0]);
	demux4 m3(w[1],sel[1:0],y[7:4]);
	demux4 m4(w[2],sel[1:0],y[11:8]);
	demux4 m5(w[3],sel[1:0],y[15:12]);
endmodule
