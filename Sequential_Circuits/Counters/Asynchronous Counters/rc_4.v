module tff(t,clk,rst,q,qbar);
	input t,clk,rst;
	output reg q;
	output qbar;
	assign qbar=~q;
	always @(negedge clk or posedge rst) begin
		if(!rst)
			q<=1'b0;
		else if(t)
			q<=~q;
	end
endmodule

module rc_4(clk,rst,q);
	input clk,rst;
	output [3:0]q;
	wire [3:0]qbar;
	tff t0(1'b1,clk,rst,q[0],qbar[0]);
	tff t1(1'b1,qbar[0],rst,q[1],qbar[1]);
	tff t2(1'b1,qbar[1],rst,q[2],qbar[2]);
	tff t3(1'b1,qbar[2],rst,q[3],qbar[3]);
endmodule
