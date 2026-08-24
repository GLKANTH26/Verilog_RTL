module not_cmos(y,a);
  output y;
  input a;
  supply1 vdd;
  supply0 gnd;
  
  pmos p1(y,vdd,a);
  nmos n1(y,gnd,a);
endmodule

module nand_cmos(y,a,b);
  output y;
  input a,b;
  supply1 vdd;
  supply0 gnd;
  wire w1;
  
  pmos p1(y,vdd,a);
  pmos p2(y,vdd,b);
  nmos n1(w1,gnd,a);
  nmos n2(y,w1,b);
endmodule

module nor_cmos(y,a,b);
  output y;
  input a,b;
  supply1 vdd;
  supply0 gnd;
  wire w1;
  
  pmos p1(w1,vdd,a);
  pmos p2(y,w1,b);
  nmos n1(y,gnd,a);
  nmos n2(y,gnd,b);
endmodule

module and_cmos(y,a,b);
  output y;
  input a,b;
  wire w1_nand;

  nand_cmos n1(w1_nand,a,b);
  not_cmos  i1(y,w1_nand);
endmodule

module or_cmos(y,a,b);
  output y;
  input a,b;
  wire w1_nor;

  nor_cmos n1(w1_nor,a,b);
  not_cmos i1(y,w1_nor);
endmodule

module xor_cmos(y,a,b);
  output y;
  input a,b;
  wire na,nb,w1,w2;
  wire w1_nand,w1_nmos,w2_nand,w2_nmos,y_nor,y_pmos;
  supply1 vdd;
  supply0 gnd;

  pmos p_na(na,vdd,a);
  nmos n_na(na,gnd,a);

  pmos p_nb(nb,vdd,b);
  nmos n_nb(nb,gnd,b);

  pmos p_w1_1(w1_nand,vdd,a);
  pmos p_w1_2(w1_nand,vdd,nb);
  nmos n_w1_1(w1_nmos,gnd,a);
  nmos n_w1_2(w1_nand,w1_nmos,nb);
  pmos p_w1_3(w1,vdd,w1_nand);
  nmos n_w1_3(w1,gnd,w1_nand);

  pmos p_w2_1(w2_nand,vdd,na);
  pmos p_w2_2(w2_nand,vdd,b);
  nmos n_w2_1(w2_nmos,gnd,na);
  nmos n_w2_2(w2_nand,w2_nmos,b);
  pmos p_w2_3(w2,vdd,w2_nand);
  nmos n_w2_3(w2,gnd,w2_nand);

  pmos p_y_1(y_pmos,vdd,w1);
  pmos p_y_2(y_nor,y_pmos,w2);
  nmos n_y_1(y_nor,gnd,w1);
  nmos n_y_2(y_nor,gnd,w2);
  pmos p_y_3(y,vdd,y_nor);
  nmos n_y_3(y,gnd,y_nor);
endmodule

module full_adder_cmos(a,b,c_in,sum,c_out);
  input a,b,c_in;
  output sum,c_out;
  
  wire w_sum1;
  wire w_cout1,w_cout2;

  xor_cmos x1(w_sum1,a,b);
  
  and_cmos a1(w_cout1,a,b);
  
  xor_cmos x2(sum,w_sum1,c_in);
  
  and_cmos a2(w_cout2,w_sum1,c_in);
  
  or_cmos o1(c_out,w_cout1,w_cout2);
  
endmodule
