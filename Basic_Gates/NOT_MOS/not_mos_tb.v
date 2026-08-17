`include "not_mos.v"
module mos_not_tb;
	reg a;
	wire y_not;
	mos_not n1(a,y_not);
	initial begin 
		$fsdbDumpvars();
	end
	initial begin
		a=0;
		#10;
		$display("Time = %0t a=%b y=%b",$time,a,y_not);
		a=1;
		#10;
		$display("Time = %0t a=%b y=%b",$time,a,y_not);
		$finish;
	end
endmodule
