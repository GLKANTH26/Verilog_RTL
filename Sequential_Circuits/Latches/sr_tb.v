`include "sr.v"
module tb_sr_latch;
	reg s,r;
	wire q;
	sr latch(s,r,q);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t s=%b r=%b q=%b qbar=%b",$time,s,r,q,~q);
		s=0;r=0;
		#10 s=1;r=0;
		#10 s=0;r=0;
		#10 s=0;r=1;
		#10 s=0;r=0;
		#10 s=1;r=1;
		#10 s=0;r=0;
		#10 $finish;
	end
endmodule
