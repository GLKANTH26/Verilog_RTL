module ha_and_hs(a,b,x,res,cout);
    input a,b,x;
    output res,cout;
    wire w1;
    xor x1(res,a,b);
    xor x2(w1,a,x);
    and a1(cout,w1,b);
endmodule

