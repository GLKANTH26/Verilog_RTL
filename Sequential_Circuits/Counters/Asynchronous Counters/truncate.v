module jk(j,k,clk,rst,q,qbar);
	input j,k,clk,rst;
	output reg q;
	output qbar;
	assign qbar=~q;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			q<=1'b0;
		else begin
			case({j,k})
				2'b00: q<=q;
				2'b01: q<=1'b0;
				2'b10: q<=1'b1;
				2'b11: q<=~q;
				default: q<=1'bx;
			endcase
		end
	end
endmodule

module truncate(clk,rst,q);
	input clk,rst;
	output [3:0]q;
	wire [3:0]qbar;
	wire trunc;
	wire final;
	nand n1(trunc,q[3],q[1]);
	and a1(final,rst,trunc);
	jk t0(1'b1,1'b1,clk,final,q[0],qbar[0]);
	jk t1(1'b1,1'b1,qbar[0],final,q[1],qbar[1]);
	jk t2(1'b1,1'b1,qbar[1],final,q[2],qbar[2]);
	jk t3(1'b1,1'b1,qbar[2],final,q[3],qbar[3]);
endmodule
