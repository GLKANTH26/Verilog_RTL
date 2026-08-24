module half_sub(input a,b,output d,bo);
    xor(d,a,b);
    and(bo,~a,b);
endmodule
