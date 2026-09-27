`include "8by1.v"
`include "4by1.v"
module mux32by1(in,sel,y);
    input [31:0]in;
    input [4:0]sel;
    output y;
    wire [3:0]w;
    wire [7:0] w1,w2,w3,w4;
    assign w1=in[7:0];
    assign w2=in[15:8];
    assign w3=in[23:16];
    assign w4=in[31:24];
    mux8 m0(w1,sel[2:0],w[0]);
    mux8 m1(w2,sel[2:0],w[1]);
    mux8 m2(w3,sel[2:0],w[2]);
    mux8 m3(w4,sel[2:0],w[3]);
    mux4 m4(w,sel[4:3],y);
endmodule

