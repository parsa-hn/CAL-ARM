module MEM_Stage_Reg(
    input clk, rst, cache_freeze, WB_en_in, MEM_R_en_in,
    input [31:0] ALU_result_in, Mem_read_value_in,
    input [3:0] Dest_in,
    output reg WB_en, MEM_R_en,
    output reg [31:0] ALU_result, Mem_read_value,
    output reg [3:0] Dest
    );
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            WB_en <= 1'b0;
            MEM_R_en <= 1'b0;
            ALU_result <= 32'b0;
            Mem_read_value <= 32'b0;
            Dest <= 4'b0;
        end
        else if (~cache_freeze) begin
            WB_en <= WB_en_in;
            MEM_R_en <= MEM_R_en_in;
            ALU_result <= ALU_result_in;
            Mem_read_value <= Mem_read_value_in;
            Dest <= Dest_in;
        end
    end

endmodule