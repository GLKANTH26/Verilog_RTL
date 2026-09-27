module mux4(a,b,c,d,sel,y);
	input a,b,c,d;
	input [1:0]sel;
	output reg y;
	always @(*) begin
		case(sel)
		2'b00: y=a;
		2'b01: y=b;
		2'b10: y=c;
		2'b11: y=d;
		default: y=1'bx;
		endcase
	end
endmodule


module mux16(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,sel,y);
	input a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;
	input [3:0]sel;
	output y;
	wire w0,w1,w2,w3;
	mux4 m0(a,b,c,d,sel[1:0],w0);
	mux4 m1(e,f,g,h,sel[1:0],w1);
	mux4 m2(i,j,k,l,sel[1:0],w2);
	mux4 m3(m,n,o,p,sel[1:0],w3);
	mux4 m_final(w0,w1,w2,w3,sel[3:2],y);
endmodule
