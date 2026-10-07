module siso#(parameter N=8)(s_in,en,clk,rst,s_out);
	input s_in,en,clk,rst;
	output s_out;
	reg [N-1:0]q_reg;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			q_reg<=0;
		else if(en)
			q_reg<={s_in,q_reg[N-1:1]};
	end
	assign s_out=q_reg[0];
endmodule
