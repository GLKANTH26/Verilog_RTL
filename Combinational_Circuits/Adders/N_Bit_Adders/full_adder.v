module full_adder(a,b,c_in,sum,c_out);
  input a,b,c_in;
  output sum,c_out;
  
  wire w_sum_ha1;
  wire w_cout_ha1;
  wire w_cout_ha2;

  xor x1(w_sum_ha1,a,b);
  and a1(w_cout_ha1,a,b);
  
  xor x2(sum,w_sum_ha1,c_in);
  and a2(w_cout_ha2,w_sum_ha1,c_in);
  
  or o1(c_out,w_cout_ha1,w_cout_ha2);
  
endmodule
