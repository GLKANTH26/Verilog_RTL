module jk(j,k,clk,rst,q,qbar);
	input j,k,clk,rst;
	output reg q;
	output qbar;
	assign qbar=~q;
	always @(negedge clk or posedge rst) begin
		if(rst)
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

module rc_3(clk,rst,q);
	input clk,rst;
	output [3:0]q;
	wire [3:0]qbar;
	jk t0(1'b1,1'b1,clk,rst,q[0],qbar[0]);
	jk t1(1'b1,1'b1,q[0],rst,q[1],qbar[1]);
	jk t2(1'b1,1'b1,q[1],rst,q[2],qbar[2]);
	jk t3(1'b1,1'b1,q[2],rst,q[3],qbar[3]);
endmodule


