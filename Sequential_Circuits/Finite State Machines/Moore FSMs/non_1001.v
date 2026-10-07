module non_1001(input wire clk,input wire rst,input wire in,output wire det);
    localparam S_0=3'b000;
    localparam S_1=3'b001;
    localparam S_2=3'b010;
    localparam S_3=3'b011;
    localparam S_4=3'b100;
    reg [2:0] cs,ns;
    assign det=(cs==S_4);
    always @(posedge clk or negedge rst) begin
        if(!rst) cs<=S_0;
        else cs<=ns;
    end
    always @(*) begin
        ns=S_0;
        case(cs)
            S_0: begin
                if(in) ns=S_1;
                else ns=S_0;
            end
            S_1: begin
                if(in) ns=S_1;
                else ns=S_2;
            end
            S_2: begin
                if(in) ns=S_1;
                else ns=S_3;
            end
            S_3: begin
                if(in) ns=S_4;
                else ns=S_0;
            end
            S_4: begin
                if(in) ns=S_1;
                else ns=S_0;
            end
            default: ns=S_0;
        endcase
    end
endmodule
