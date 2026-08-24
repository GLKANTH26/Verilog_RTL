`include "half_sub.v"


module full_sub_hier(a,b,c,d,bo);
input a,b,c;
output d,bo;
wire w1,w2,w3;
half_sub hs1(a,b,w1,w2);
half_sub hs2(w1,c,d,w3);
or o1(bo,w2,w3);
endmodule

