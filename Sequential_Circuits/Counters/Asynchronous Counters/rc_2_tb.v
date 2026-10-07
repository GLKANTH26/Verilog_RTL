`include "rc_2.v"
module rc_2_tb;
	reg clk,rst;
	wire [3:0]q;
	rc_2 rc(clk,rst,q);
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
	always @(posedge clk) begin
		if(rst)
		$display("T=%0t q=%b or %d",$time,q,q);
	end
endmodule
