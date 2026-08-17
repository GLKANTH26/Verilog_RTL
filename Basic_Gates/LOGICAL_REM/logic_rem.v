module logic_nor(input a,b,output y);
	assign y = ~(a|b);
endmodule

module logic_and(input a,b,output y);
	assign y = a&b;
endmodule

module logic_or(input a,b,output y);
	assign y = a|b;
endmodule

module logic_xor(input a,b,output y);
	assign y = a^b;
endmodule

module logic_xnor(input a,b,output y);
	assign y = ~(a^b);
endmodule


