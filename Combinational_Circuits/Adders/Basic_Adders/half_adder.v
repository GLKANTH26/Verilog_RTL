module half_adder(a,b,s,cout);
	output reg s,cout;
	input wire a,b;
	always @(*) begin
		s=a^b;
		cout=a & b;
	end
endmodule

// We can also use a single line code {cout,s} = a+b
