`include "rc_4.v"
module rc_4_tb;
	reg clk,rst;
	wire [3:0]q;
	rc_4 dc2(clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		rst=0;
		#8 rst=1;
		#160 $finish;
	end
	always @(negedge clk) begin
		if(rst)
		$display("T=%0t q=%b",$time,q,q);
	end
endmodule
