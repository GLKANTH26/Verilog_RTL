`include "cmos_rem.v"

module cmos_rem_tb;
	reg a,b;
	wire y_nor,y_and,y_or,y_xor,y_xnor;
	nor_cmos g1(a,b,y_nor);
	and_cmos g2(a,b,y_and);
	or_cmos g3(a,b,y_or);
	xor_cmos g4(a,b,y_xor);
	xnor_cmos g5(a,b,y_xnor);
	
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


