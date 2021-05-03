module WB_Stage_Reg(
    input clk, rst,
    input [31:0] PC_in,
    output reg [31:0] PC
    );

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC <= 32'b0;
        end
        else if (clk) begin
            PC <= PC_in;
        end
    end
    
endmodule