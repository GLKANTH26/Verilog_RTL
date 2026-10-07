`include "rc_3.v"
module rc_3_tb;
	reg clk,rst;
	wire [3:0]q;
	rc_3 uc2(clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		rst=1;
		#8 rst=0;
		#160 $finish;
	end
	always @(negedge clk) begin
		if(!rst)
		$display("T=%0t q=%b or %d",$time,q,q);
	end
endmodule
