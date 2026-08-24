module fa_fs(a,b,c,sub,res,cout);
  input a,b,c,sub;
  output res,cout;
  wire w1,w2,w3,w4;
  xor x1(w1,b,sub);
  xor x2(w2,a,w1);
  and a1(w3,a,w1);
  xor x3(res,w2,c);
  and a2(w4,w2,c);
  or o1(cout,w3,w4);
endmodule
module nbit_fa_fs#(parameter N=8)(a,b,c,sub,res,cout);
  input [N-1:0] a,b;
  input c,sub;
  output [N-1:0] res;
  output cout;
  wire [N:0] cc;
  genvar i;
  assign cc[0]=c|sub;
  generate
    for(i=0;i<N;i=i+1) begin:fa_sub_stage
      fa_fs dut(a[i],b[i],cc[i],sub,res[i],cc[i+1]);
    end
  endgenerate
  assign cout=cc[N];
endmodule

