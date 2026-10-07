module piso#(parameter N=8)(p_in,ld,en,clk,rst,s_out);
	input [N-1:0]p_in;
	input ld,en,clk,rst;
	output s_out;
	reg [N-1:0]q_reg;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			q_reg<=0;
		else if(ld)
			q_reg<=p_in;
		else if(en)
			q_reg<={1'b0,q_reg[N-1:1]};
	end
	assign s_out=q_reg[0];
endmodule
