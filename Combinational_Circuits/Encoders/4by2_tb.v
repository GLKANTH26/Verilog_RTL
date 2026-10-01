`include "4by2.v"
module enc4by2_tb;
	reg [3:0]in;
	wire [1:0]y;
	reg en;
	enc4by2 e42(in,en,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t en=%b in=%b y=%b",$time,en,in,y);
		en=1'b1;
		in=4'b0001;
		#10 in=4'b0100;
		#10 in=4'b0000;
		#10 in=4'b0110;
		#10 en=1'b0;
		#10 in=4'b1000;
		#10 $finish;
	end
endmodule
