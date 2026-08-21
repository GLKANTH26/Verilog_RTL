module half_adder(sum,c_out,a,b);
  output sum,c_out;
  input a,b;
  
  xor x1(sum,a,b);
  and a1(c_out,a,b);
endmodule

module full_adder(a,b,c_in,sum,c_out);
  input a,b,c_in;
  output sum,c_out;
  
  wire w_sum1;
  wire w_cout1,w_cout2;

  half_adder ha1(w_sum1,w_cout1,a,b);
  half_adder ha2(sum,w_cout2,w_sum1,c_in);
  or o1(c_out,w_cout1,w_cout2);
  
endmodule
