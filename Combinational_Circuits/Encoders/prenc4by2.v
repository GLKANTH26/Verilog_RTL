module prenc4by2(in,en,y,valid);
	input [3:0]in;
	input en;
	output reg [1:0]y;
	output reg valid;
	always @(*) begin
		if(en)begin
			y=2'bx;
			valid=1'b1;
			if(in[3]) y=2'b11;
			else if(in[2]) y=2'b10;
			else if(in[1]) y=2'b01;
			else if(in[0]) y=2'b00;
			else begin
				valid=1'b0;
				y=2'bx;
			end
		end
		else begin
		valid=1'b0;
		y=2'bx;
		end
	end
endmodule


