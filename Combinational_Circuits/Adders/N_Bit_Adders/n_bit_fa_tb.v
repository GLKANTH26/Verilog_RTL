`include "n_bit_fa.v"

module n_bit_fa_tb;

  localparam W8 = 8;
  reg [W8-1:0] a8,b8;
  reg cin8;
  wire [W8-1:0] sum8;
  wire cout8;

  n_bit_fa #(W8) nfa(a8,b8,cin8,sum8,cout8);

  initial begin
    $fsdbDumpvars();

    $monitor("T=%0t a=%d b=%d c_in=%b sum=%d c_out=%b",$time, a8,b8,cin8,sum8,cout8);          
    a8=5;b8=2;cin8=0;
    #10;
    a8=100;b8=50;cin8=1;
    #10;
    a8=255; b8=1;cin8=0;
    #10;
    $finish;
  end
  
endmodule
