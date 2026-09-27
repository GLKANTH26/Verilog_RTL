`include "hier_32by1.v"
module tb_mux32by1;
    reg [31:0] in;
    reg [4:0] sel;
    wire y;
    mux32by1 m32(in,sel,y);
    initial begin
        $fsdbDumpvars();
        $monitor("T=%0t sel=%d in=%h y=%b",$time,sel,in,y);
        in=32'h00000001; sel= 0; #10;
	in=32'h00000002; sel= 1; #10;
	in=32'h00000004; sel= 2; #10;
	in=32'h00000008; sel= 3; #10;
	in=32'h20000000; sel=29; #10;
	in=32'h40000000; sel=30; #10;
	in=32'h80000000; sel=31; #10;
        $finish;
    end
endmodule

