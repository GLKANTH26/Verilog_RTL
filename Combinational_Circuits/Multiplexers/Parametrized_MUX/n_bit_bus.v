module n_bit_bus#(parameter N=8,parameter WIDTH=8)(in,sel,y);
	localparam SEL_WIDTH=$clog2(N);
	input [WIDTH-1:0]in[0:N-1];
	input [SEL_WIDTH-1:0] sel;
	output [WIDTH-1:0] y;
	assign y = in[sel];
endmodule
