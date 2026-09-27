module demux4(in,sel,y);
	input in;
	input [1:0]sel;
	output reg [3:0]y;
	always @(*) begin
		y = 4'b0000;
		case(sel)
			2'b00: y[0]=in;
			2'b01: y[1]=in;
			2'b10: y[2]=in;
			2'b11: y[3]=in;
			default: y=4'bx;
		endcase
	end
endmodule

