module mux4(in,sel,y);
	input [3:0]in;
	input [1:0]sel;
	output reg y;
	always @(*) begin
		case(sel)
			2'b00: y=in[0];
			2'b01: y=in[1];
			2'b10: y=in[2];
			2'b11: y=in[3];
			default: y=1'bx;
		endcase
	end
endmodule

module mux4_t(a,b,c,d,sel,y);
	input a,b,c,d;
	input [1:0]sel;
	output y;
	assign y = (sel == 2'b00) ? a:(sel == 2'b01) ? b:(sel == 2'b10) ? c:d;
endmodule



