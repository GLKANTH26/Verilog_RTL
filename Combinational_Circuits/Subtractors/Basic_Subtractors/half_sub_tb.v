`include "half_sub.v"
module half_sub_tb;
    reg a,b;
    wire d,bo;
    half_sub hs(a,b,d,bo);
    initial begin
        $fsdbDumpvars();
        $monitor("Time = %0t a=%b b=%b Diff=%b Borrow=%b",$time,a,b,d,bo);
        a=0;b=0;
        #10 a=0;b=1;
        #10 a=1;b=0;
        #10 a=1;b=1;
        #10 $finish;
    end
endmodule

