`include "n_bit_bus.v"
module n_bit_bus_tb;
	localparam N=4;
	localparam WIDTH=8;
	reg [WIDTH-1:0] in [0:N-1];
	reg [$clog2(N)-1:0] sel;
	wire [WIDTH-1:0] y;

	n_bit_bus#(N,WIDTH) nbbs(in,sel,y);

	initial begin
	$fsdbDumpvars();
	$monitor("T=%0t sel=%b y=%h",$time,sel,y);
	in[0]=8'hAA;
	in[1]=8'hBB;
	in[2]=8'hCC;
	in[3]=8'hDD;
	sel=2'b00;
	#10 sel=2'b01;
	#10 sel=2'b10;
	#10 sel=2'b11;
	#10 sel=2'bx;
	#10 $finish;
	end
endmodule
