module johnson#(parameter N=4)(en,clk,rst,q);
	input en,clk,rst;
	output reg [N-1:0]q;
	always @(posedge clk or negedge rst) begin
	if(!rst)
		q<=0;
	else if(en)
		q<={q[N-2:0],~q[N-1]};
	end
endmodule
