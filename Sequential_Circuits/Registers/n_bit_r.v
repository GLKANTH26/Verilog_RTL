module usr#(parameter N=8)(d,sr,sl,sel,clk,rst,q);
	input [N-1:0]d;
	input sr,sl;
	input [1:0]sel;
	input clk,rst;
	output reg [N-1:0]q;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			q<=0;
		else begin
			case(sel)
				2'b00: q<=q;
				2'b01: q<={sr,q[N-1:1]};
				2'b10: q<={q[N-2:0],sl};
				2'b11: q<=d;
				default: q<=q;
			endcase
		end
	end
endmodule
