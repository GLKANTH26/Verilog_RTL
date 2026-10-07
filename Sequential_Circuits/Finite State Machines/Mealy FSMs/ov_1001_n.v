module mealy_1001_non_ov (input wire clk,input wire rst,input wire in,output reg det);
    localparam S_0=2'b00;
    localparam S_1=2'b01;
    localparam S_2=2'b10;
    localparam S_3=2'b11;
    reg [1:0] cs,ns;
    always @(posedge clk or negedge rst) begin
        if (!rst)
            cs<=S_0;
        else
            cs<=ns;
    end

    always @(*) begin
        det=0;
        ns=S_0;

        case(cs)
            S_0: begin
                if(in) ns=S_1;
                else   ns=S_0;
            end

            S_1: begin
                if(in) ns=S_1;
                else   ns=S_2;
            end

            S_2: begin
                if(in) ns=S_1;
                else   ns=S_3;
            end

            S_3: begin
                if(in) begin
                    det=1;
                    ns=S_0; 
                end else begin
                    det=0;
                    ns=S_0; 
                end
            end

            default: begin
                ns=S_0;
                det=0;
            end
        endcase
    end

endmodule
