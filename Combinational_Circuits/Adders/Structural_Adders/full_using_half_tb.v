`include "fuh.v"

module fuh_tb;
  reg a,b,c_in;
  wire sum,c_out;

  full_adder fh(a,b,c_in,sum,c_out);

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
