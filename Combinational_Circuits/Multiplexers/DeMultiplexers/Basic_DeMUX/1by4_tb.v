`include "1by4.v"
module dem1by4_tb;
	reg in;
	reg [1:0]sel;
	wire [3:0] y;
	demux4 d1(in,sel,y);
	initial begin
		$fsdbDumpvars();
		$monitor("Time=%0t , in = %b , en=%b , y[0] = %b , y[1]=%b , y[0] = %b , y[1]=%b",$time,in,sel,y[0],y[1],y[2],y[3]);
		in=1'b1;
		sel=2'b00;
		#10 sel=2'b01;
		#10 sel=2'b10;
		#10 sel=2'b11;
		#10 $finish;
	end
endmodule
