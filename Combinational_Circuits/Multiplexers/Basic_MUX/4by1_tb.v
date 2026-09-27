`include "4by1.v"
module mux4by1_tb;
	reg a,b,c,d;
	reg [1:0] sel;
	wire y1,y2;
	mux4 m41(a,b,c,d,sel,y1);
	mux4_t m42(a,b,c,d,sel,y2);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t sel=%b a=%b b=%b c=%b d=%b y_case=%b y_ternary=%b",$time,sel,a,b,c,d,y1,y2);
		a=1'b0;b=1'b0;c=1'b1;d=1'b1;sel=2'b00;
		#10 sel=2'b01;
		#10 sel=2'b10;
		#10 sel=2'b11;
		#10 a=1'b1;b=1'b1;c=1'b0;d=1'b0;
		#10 sel=2'b00;
		#10 sel=2'b01;
		#10 sel=2'b10;
		#10 sel=2'b11;
		#10 $finish;
	end
endmodule
