`include "half_adder.v"

module half_adder_tb;
	reg a,b;
	wire s,c;
	half_adder ha(a,b,s,c);
	initial begin
		$fsdbDumpvars();
		$monitor("Time = %0t,a=%b,b=%b,sum=%b,cout=%b",$time,a,b,s,c);
		a=1'bx;b=1'bx;
		#10 a=0;b=0;
		#10 a=0;b=1;
		#10 a=1;b=0;
		#10 a=1;b=1;
		#10 $finish;
	end
endmodule
