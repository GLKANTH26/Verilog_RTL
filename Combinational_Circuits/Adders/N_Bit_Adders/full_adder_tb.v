`include "full_adder.v"

module tb_full_adder_builtin;
  reg a,b,c_in;
  wire sum,c_out;

  full_adder fa(.a(a),.b(b),.c_in(c_in),.sum(sum),.c_out(c_out));

  initial begin
    $fsdbDumpvars();

    $monitor("T=%0t a=%b b=%b c_in=%b sum=%b c_out=%b",$time,a,b,c_in,sum,c_out);
             
    a=0;b=0;c_in=0;
    #10 c_in=1;
    #10 b=1;c_in=0;
    #10 c_in=1;
    #10 a=1;b=0;c_in=0;
    #10 c_in=1;
    #10 b=1;c_in=0;
    #10 c_in=1;
    #10 $finish;
  end
  
endmodule
