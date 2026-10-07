module ov_moore_1001(input wire clk,input wire rst,input wire in,output wire det);

    localparam S_1= 3'b000;
    localparam S_2= 3'b001;
    localparam S_3= 3'b010;
    localparam S_4= 3'b011;
    localparam S_5= 3'b100;

    reg [2:0] cs,ns;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            cs<=S_1;
        else
            cs<=ns;
    end

    assign det=(cs==S_5);

    always @(*) begin
        ns=cs;
        case(cs)
            S_1: begin
                if(in) ns=S_2;
                else   ns=S_1;
            end
            S_2: begin
                if(in) ns=S_2;
                else   ns=S_3;
            end
            S_3: begin
                if(in) ns=S_2;
                else   ns=S_4;
            end
            S_4: begin
                if(in) ns=S_5;
                else   ns=S_1;
            end
            S_5: begin
                if(in) ns=S_2;
                else   ns=S_3;
            end
            default: ns=S_1;
        endcase
    end

endmodule
