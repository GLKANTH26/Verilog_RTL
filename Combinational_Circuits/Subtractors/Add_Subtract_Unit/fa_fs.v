module fa_and_fs(a,b,c,x,res,cout);
    input a,b,c,x;
    output res,cout;
    wire w1,w2,w3,w4,w5;


    xor x1(w1,a,b);
    xor x2(res,w1,c);
    xor x3(w2,a,x);
    xor x4(w4,w1,x);
    and a1(w3,w2,b);
    and a2(w5,w4,c);
    or(cout,w3,w5);
endmodule

