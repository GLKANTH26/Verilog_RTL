`include "not_bltin.v"
module not_bltin_tb;
	reg a;
	wire y;
	not_bltin n1(a,y);
	initial begin
		$fsdbDumpvars();
	end
	initial begin
		$monitor("Time = %0t A = %b Y = %b",$time,a,y);
		a=0;
		#10;
		a=1;
		#10;
		$finish;
	end
endmodule
	 
