`include "full_sub.v"
module full_sub_tb;
	reg a,b,c;
	wire d,bo;
	full_sub fs(a,b,c,d,bo);
	initial begin
		$fsdbDumpvars();
		$monitor("Time = %0t a=%b b=%b c=%b diff=%b borrow=%b", $time,a,b,c,d,bo);
		{a,b,c} = 3'b000;
		#10;
		{a,b,c} = 3'b001;
		#10;
		{a,b,c} = 3'b010;
		#10;
		{a,b,c} = 3'b011;
		#10;
		{a,b,c} = 3'b100;
		#10;
		{a,b,c} = 3'b101;
		#10;
		{a,b,c} = 3'b110;
		#10;
		{a,b,c} = 3'b111;
		#10;
		$finish;
	end
endmodule
