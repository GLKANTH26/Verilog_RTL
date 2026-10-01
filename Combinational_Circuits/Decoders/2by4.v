module decoder2by4(in,en,y);
	input [1:0]in;
	input en;
	output reg [3:0]y;
	always @(*) begin
		y=4'b0000;
		if(en) begin
			case(in)
				2'b00:y[0]=1'b1;
				2'b01:y[1]=1'b1;
				2'b10:y[2]=1'b1;
				2'b11:y[3]=1'b1;
				default: y=4'bx;
			endcase
		end
	end
endmodule
