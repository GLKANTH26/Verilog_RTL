module pipo#(parameter N=8)(d,ld,clk,rst,q);
	input [N-1:0]d;
	input ld,clk,rst;
	output reg [N-1:0]q;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			q<=0;
		else if(ld)
			q<=d;
	end
endmodule
