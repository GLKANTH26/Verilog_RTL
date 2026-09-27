`include "1by8.v"
module demux1by8_tb;
	reg in;
	reg [2:0]sel;
	wire [7:0]y;
	demux1by8 m18(in,sel,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t in=%b sel=%b y=%b",$time,in,sel,y);
		in=1'b1;
		sel=3'b000;
		#10 sel=3'b011;
		#10 sel=3'b111;
		#10 in=1'b0;
		#10 sel=3'b000;
		#10 sel=3'b011;
		#10 sel=3'b111;
		#10 $finish;
	end
endmodule
