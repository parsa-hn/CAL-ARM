module Condition_Check(
    input N, Z, C, V,
    input [3:0] cond,
    output reg check
    );

    always @(*) begin
        case(cond)
            4'b0000 : check = (Z == 1) ? 1'b1 : 1'b0;
            4'b0001 : check = (Z == 0) ? 1'b1 : 1'b0;
            4'b0010 : check = (C == 1) ? 1'b1 : 1'b0;
            4'b0011 : check = (C == 0) ? 1'b1 : 1'b0;
            4'b0100 : check = (N == 1) ? 1'b1 : 1'b0;
            4'b0101 : check = (N == 0) ? 1'b1 : 1'b0;
            4'b0110 : check = (V == 1) ? 1'b1 : 1'b0;
            4'b0111 : check = (V == 0) ? 1'b1 : 1'b0;
            4'b1000 : check = (C == 1 && Z == 0) ? 1'b1 : 1'b0;
            4'b1001 : check = (C == 0 || Z == 1) ? 1'b1 : 1'b0;
            4'b1010 : check = (N == V) ? 1'b1 : 1'b0;
            4'b1011 : check = (N != V) ? 1'b1 : 1'b0;
            4'b1100 : check = (Z == 0 && N == V) ? 1'b1 : 1'b0;
            4'b1101 : check = (Z == 1 && N != V) ? 1'b1 : 1'b0;
            4'b1110 : check = 1'b1;
            4'b1111 : check = 1'b0;
        endcase
    end
    
endmodule