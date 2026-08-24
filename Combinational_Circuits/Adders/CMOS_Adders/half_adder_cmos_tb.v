`include "using_cmos.v"


module usingcmos_tb;
  reg a,b;
  wire sum,cout;


  half_adder ha(a,b,sum,cout);


  initial begin
    $fsdbDumpvars();
    $monitor("T=%0t , a=%b , b=%b , sum=%b , cout=%b",$time,a,b,sum,cout);
    a=0;b=0;
    #10 a=0;b=1;
    #10 a=1;b=0;
    #10 a=1;b=1;
    #10 $finish;
  end
endmodule

