
`include "ov1001.v"
module ov_1001_mealy_tb;
	reg in,clk,rst;
	wire det;
	ov_mealy_1001 dut(clk,rst,in,det);
	initial begin
		clk=1'b0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("Time = %0t , rst = %b , in = %b , Detected = %b",$time,rst,in,det);
		rst=0;in=0;
		#10 rst=1;in=1;
		#10 in=0;
		#10 in=0;
                #10 in=1;
		#10 in=0;
		#10 in=0;
		#10 in=1;
		#10 in=1;
		#10 in=0;
		#10 in=0;
		#10 $finish;
	end
endmodule
