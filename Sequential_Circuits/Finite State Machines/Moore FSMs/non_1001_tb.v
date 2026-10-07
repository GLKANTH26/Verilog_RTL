
`include "non_1001.v"
module tb_moore_non_ov;
    reg clk,rst,in;
    wire det;
    non_1001 dut(clk,rst,in,det);
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    initial begin
        $fsdbDumpvars();
	$monitor("Time=%0t,rst=%b,in=%b,det=%b",$time,rst,in,det);
        rst=0;in=0;
        @(negedge clk); rst=1;
        drive(1);
        drive(0);
        drive(0);
        drive(1);
        drive(0);
        drive(0);
        drive(1);
        #20;
        $finish;
    end
    task drive(input i);
    begin
        @(negedge clk);
        in=i;
    end
    endtask
endmodule
