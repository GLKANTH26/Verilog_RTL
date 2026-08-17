`include "not_logic.v"
module not_logic_tb;
	reg a;
	wire y;
	not_logic n1(a,y);
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
	
