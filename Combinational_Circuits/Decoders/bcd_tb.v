`include "bcd.v"
module bcd_tb;
	reg [3:0]in;
	reg en;
	wire [6:0]out;
	integer i;
	decoder bcddec(in,en,out);
	initial begin
	$fsdbDumpvars();
	$monitor("T=%0t en=%b BCD num=%d Segments(abcdefg): %b",$time,en,in,out);
	en=1'b0;in=4'b0101;
	#10 en=1'b1;in=4'b0000;
	#10 in=4'b0001;
	#10 in=4'b0111;
	#10 in=4'b1001;
	#10 in=4'b1010;
	#10 in=4'b1111;
	#10 $finish;
	end
endmodule
