module Register_File(
    input clk, rst,
    input [3:0] src1, src2, WB_dest,
    input [31:0] WB_val,
    input WB_en,
    output [31:0] reg1, reg2
    );

    reg [31:0] registers [0:14];
    integer i;

    always @(negedge clk, posedge rst) begin
         if (rst) begin
            for (i = 0; i < 15; i = i + 1)
                registers[i] <= i;
        end
        else if (WB_en) begin
            registers[WB_dest] <= WB_val;
        end
    end
    
    assign reg1 = registers[src1];
    assign reg2 = registers[src2];

endmodule