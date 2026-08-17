module nor_cmos(input a,b,output y);
	supply1 vdd;
	supply0 gnd;
	wire w1;
	
	pmos p1(w1,vdd,a);
	pmos p2(y,w1,b);
	nmos n1(y,gnd,a);
	nmos n2(y,gnd,b);
endmodule

module and_cmos(input a,b,output y);
	supply1 vdd;
	supply0 gnd;
	wire w1,w2;
	pmos p1(w1,vdd,a);
	pmos p2(w1,vdd,b);
	nmos n1(w2,gnd,a);
	nmos n2(w1,w2,b);
	
	pmos p3(y,vdd,w1);
	nmos n3(y,gnd,w1);
endmodule

module or_cmos(input a,b,output y);
	supply1 vdd;
	supply0 gnd;
	wire w1,w2;
	pmos p1(w2,vdd,a);
	pmos p2(w1,w1,b);
	nmos n1(w1,gnd,a);
	nmos n2(w1,gnd,b);
	
	pmos p3(y,vdd,w1);
	nmos n3(y,gnd,w1);
endmodule 

module xor_cmos(input a,b,output y);
	supply1 vdd;
	supply0 gnd;
	wire w1,w2;
	
	pmos p1(w1,vdd,a);
	nmos n1(w1,gnd,a);

	pmos p2(w2,vdd,b);
	nmos n2(w2,gnd,b);

	pmos p3(y,a,b);
	nmos n3(y,a,w2);

	pmos p4(y,w1,w2);
	nmos n4(y,w1,b);
endmodule 

module xnor_cmos(input a,b,output y);
	supply1 vdd;
	supply0 gnd;
	wire w1,w2;
	
	pmos p1(w1,vdd,a);
	nmos n1(w1,gnd,a);

	pmos p2(w2,vdd,b);
	nmos n2(w2,gnd,b);

	pmos p3(y,w1,b);
	nmos n3(y,w1,w2);

	pmos p4(y,a,w2);
	nmos n4(y,a,b);
endmodule 


