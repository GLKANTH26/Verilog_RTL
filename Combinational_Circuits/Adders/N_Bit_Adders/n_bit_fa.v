`include "full_adder.v"

module n_bit_fa#(parameter N=8)(a,b,c_in,sum,c_out);
  input [N-1:0] a,b;
  input c_in;
  output [N-1:0] sum;
  output c_out;
  wire [N:0] carry_chain;
  assign carry_chain[0] = c_in;
  genvar i;
  generate
    for (i=0; i<N; i=i+1) begin: fa_stage
      full_adder fa(a[i],b[i],carry_chain[i],sum[i],carry_chain[i+1]);
    end
  endgenerate
  
  assign c_out = carry_chain[N];

endmodule
