`include "prenc4by2.v"
module tb_encoder_4_2_priority;
	reg [3:0]in;
	reg en;
	wire [1:0]y;
	wire valid;
	prenc4by2 p42(in,en,y,valid);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t en=%b in=%b valid=%b y=%b",$time,en,in,y,valid);
		en=1'b1;
		in=4'b0001;
		#10 in=4'b0110;
		#10 in=4'b0000;
		#10 en=1'b0;
		#10 in=4'b1000;
		#10 $finish;
	end
endmodule
