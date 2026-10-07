module ring(en,clk,rst,q);
	parameter N=4;
	input en,clk,rst;
	output reg [N-1:0]q;
	always @(posedge clk or negedge rst) begin
	if(!rst)
		q<=4'b0001;
	else if(en)
		q<={q[N-2:0],q[N-1]};
	end
endmodule
