module decoder(in,en,out);
	input [3:0]in;
	input en;
	output reg [6:0]out;
	always @(*) begin
		out=7'b0000000;
		if(en) begin
			case(in)
				4'd0:out=7'b1111110;
				4'd1:out=7'b0000110;
				4'd2:out=7'b1101101;
				4'd3:out=7'b1111001;
				4'd4:out=7'b0110011;
				4'd5:out=7'b1011011;
				4'd6:out=7'b1011111;
				4'd7:out=7'b1110000;
				4'd8:out=7'b1111111;
				4'd9:out=7'b1111011;
				default:out=7'b0000000;
			endcase
		end
	end
endmodule
