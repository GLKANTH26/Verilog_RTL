module onehot(input wire in,input clk,input rst,output reg out);
	reg [3:0]cs,ns;
	localparam S_0=4'b0001;
	localparam S_1=4'b0010;
	localparam S_2=4'b0100;
	localparam S_3=4'b1000;
	always @(posedge clk or negedge rst) begin
		if(!rst)
		cs<=S_0;
		else
		cs<=ns;
	end
	always @(*) begin
		ns=S_0;
		case(cs)
			S_0: if(in) ns=S_1; else ns=S_0;
			S_1: if(in) ns=S_1; else ns=S_2;
			S_2: if(in) ns=S_3; else ns=S_0;
			S_3: if(in) ns=S_1; else ns=S_0;
		default: ns=S_0;
		endcase
	end
	always @(posedge clk or negedge rst) begin
		if(!rst)
			out<=0;
		else if(cs[3])
			out<=1;
		else
			out<=0;
	end
endmodule
