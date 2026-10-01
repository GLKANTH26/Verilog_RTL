`include "2by4.v"
module tb_decoder2_4;
	reg [1:0]in;
	reg en;
	wire [3:0]y;
	decoder2by4 dec24(in,en,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t en=%b in=%b y=%b",$time,en,in,y);
		en=1'b0;
		in=2'b00;
		#10 in=2'b01;
		#10 in=2'b10;
		#10 en=1'b1;
		#10 in=2'b00;
		#10 in=2'b01;
		#10 $finish;
	end
endmodule
