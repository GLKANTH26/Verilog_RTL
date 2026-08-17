`include "builtin_rem.v"

module builtin_rem_tb;
	reg a,b;
	wire y_nor,y_and,y_or,y_xor,y_xnor;

	b_nor n1(a,b,y_nor);
	b_and a1(a,b,y_and);
	b_or o1(a,b,y_or);
	b_xor x1(a,b,y_xor);
	b_xnor xn1(a,b,y_xnor);


	initial begin
		$fsdbDumpvars();
	end

	initial begin
		$monitor("Time = %0t , a = %b , b = %b , y_nor = %b , y_and = %b , y_or = %b , y_xor = %b , y_xnor = %b",$time,a,b,y_nor,y_and,y_or,y_xor,y_xnor);
		a=0;b=0;
		#10 a=0;b=1;
		#10 a=1;b=0;
		#10 a=1;b=1;
		#10;
		$finish;
	end
endmodule
