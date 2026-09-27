`include "8by1.v"
module mux8by1_tb;
	reg [7:0] in;
	reg [2:0] sel;
	wire y;
	mux8 m8(in,sel,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t in=%b sel=%b y=%b",$time,in,sel,y);
		in=8'b10101010;
		sel=3'b000;
		#10 sel=3'b001;
		#10 sel=3'b010;
		#10 sel=3'b011;
		#10 sel=3'b100;
		#10 sel=3'b101;
		#10 sel=3'b110;
		#10 sel=3'b111;
		#10 in=8'b01010101;
		sel=3'b000;
		#10 sel=3'b001;
		#10 sel=3'b010;
		#10 sel=3'b011;
		#10 sel=3'b100;
		#10 sel=3'b101;
		#10 sel=3'b110;
		#10 sel=3'b111;
		#10 $finish;
	end
endmodule
