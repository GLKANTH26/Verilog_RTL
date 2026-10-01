`include "prenc4by2.v"
module hier_8by3(in,en,y,valid);
	input [7:0]in;
	input en;
	output reg [2:0]y;
	output reg valid;
	wire [1:0]y_low,y_high;
	wire v_low,v_high;
	prenc4by2 pe_low(in[3:0],en,y_low,v_low);
	prenc4by2 pe_high(in[7:4],en,y_high,v_high);
	always @(*) begin
		if(en)begin
			if(v_high)begin
				y={1'b1,y_high};
				valid=1'b1;
			end
			else if(v_low)begin
				y={1'b0,y_low};
				valid=1'b1;
			end
			else begin
				y=3'bx;
				valid=1'b0;
			end
		end
		else begin
			y=3'bx;
			valid=1'b0;
		end
	end
endmodule
