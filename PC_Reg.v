module PC_Reg(
    input clk, rst, freeze,
    input [31:0] PC_in,
    output reg [31:0] PC
);

    always @(posedge clk, posedge rst) begin
        if (rst) PC <= 32'b0;
        else if (!freeze) PC <= PC_in;
    end

endmodule