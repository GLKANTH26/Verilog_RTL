`include "1by8.v"
module full_adder_demux(a,b,cin,sum,cout);
	input a,b,cin; //a,b,c are enable pins and their sum and cout determine what is the output of demux
	//We use truth table of a full adder to give the outputs of sum and cout in demux through or operation
	output sum,cout;
	wire [7:0]m;
	demux1by8 d1(1'b1,{a,b,cin},m);
	assign sum = m[1]|m[2]|m[4]|m[7];
	assign cout = m[3]|m[5]|m[6]|m[7];
endmodule
