module full_sub(input a,b,c,output d,bo);
	wire w1,w2,w3,w4,w5,w6;
	not i1(w5, a);           
	xor x1(w1,a,b);
	not i2(w6,w1);
	xor x2(d,w1,c);
	and a1(w3,w5,b);
	and a2(w4,w6,c);
	or o1(bo,w3,w4);
    
endmodule




