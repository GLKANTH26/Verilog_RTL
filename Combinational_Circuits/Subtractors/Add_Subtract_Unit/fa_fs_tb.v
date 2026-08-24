`include "fa_fs.v"

module fa_and_fs_tb;
    reg a,b,c,x;
    wire res,cout;
    fa_and_fs fafs(a,b,c,x,res,cout);
    initial begin
        $fsdbDumpvars();
	$monitor("Time = %0t a = %b b = %b c = %b Control = %b Res = %b Cout/Borrow = %b",$time,a,b,c,x,res,cout);
	{a,b,c,x} = 4'b1010;
	#10;
	{a,b,c,x} = 4'b0110;
	#10;
	{a,b,c,x} = 4'b1110;
	#10;
	{a,b,c,x} = 4'b1011;
	#10;
	{a,b,c,x} = 4'b0111;
	#10;
	{a,b,c,x} = 4'b1111;
	#10;
	$finish;
    end
endmodule

