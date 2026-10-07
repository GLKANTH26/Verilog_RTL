`include "n_bit_r.v"
module n_bit_r_tb;
	localparam N=8;
	reg [N-1:0]d;
	reg [1:0]sel;
	reg sr,sl,rst,clk;
	wire [N-1:0]q;
	usr #(N) spsr(d,sr,sl,sel,clk,rst,q);
	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t clk=%b rst=%b sel=%b d=%b s_r=%b s_l=%b q=%b",$time,clk,rst,sel,d,sr,sl,q);
		rst=0;sel=2'b11;d=8'hFF;sr=0;sl=0;
		#8 rst=1;
		#10 sel=2'b11;d=8'hAA;
		#10 sel=2'b00;d=8'hFF;
		#10 sel=2'b01;sr=1;
		#10 sel=2'b01;sr=0;
		#10 sel=2'b10;sl=1;
		#10 sel=2'b10;sl=0;
		#10 sel=2'b11;d=8'h12;
		#10 $finish;
	end
endmodule
