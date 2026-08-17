module b_nor(input a,b,output y);
	nor n1(y,a,b);
endmodule

module b_and(input a,b,output y);
	and a1(y,a,b);
endmodule

module b_or(input a,b,output y);
	or o1(y,a,b);
endmodule

module b_xor(input a,b,output y);
	xor x1(y,a,b);
endmodule

module b_xnor(input a,b,output y);
	xnor xn1(y,a,b);
endmodule


