`include "fulladder.v"
module tb_full_adder_demux;
	reg a,b,cin;
	wire sum,cout;
	full_adder_demux fam(a,b,cin,sum,cout);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t a=%b b=%b c_in=%b sum=%b c_out=%b",$time,a,b,cin,sum,cout);
		{a,b,cin}=3'b000;
		#10 {a,b,cin}=3'b001;
		#10 {a,b,cin}=3'b011;
		#10 {a,b,cin}=3'b111;
		#10 $finish;
	end
endmodule
