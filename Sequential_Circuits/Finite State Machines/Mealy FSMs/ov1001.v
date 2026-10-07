module ov_mealy_1001(input wire clk,input wire rst,input wire in,output reg det);
	localparam S_1=2'b00;
	localparam S_2=2'b01;
	localparam S_3=2'b10;
	localparam S_4=2'b11;
	reg [1:0] cs,ns;
	always @(posedge clk or negedge rst) begin
		if(!rst)
			cs<=S_1;
		else 
			cs<=ns;
	end
	always @(*) begin
		det=1'b0;
		ns=S_1;
		case(cs)
			S_1:begin
			if(in) begin
				 ns=S_2;
			end
			else begin
				ns=S_1;
			end
			end
			S_2: begin
			if(in) begin
				ns=S_2;
			end
			else begin
				ns=S_3;
			end
			end
			S_3: begin
			if(in) begin
				ns=S_2;
			end
			else begin
				ns=S_4;
			end
			end
			S_4: begin
			if(in) begin
				ns=S_2;
				det=1'b1;
			end
			else begin
				ns=S_1;
			end
			end
			default:begin
			ns=S_1;
			det=1'b0;
			end
		endcase
	end
endmodule
