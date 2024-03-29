module ID_Stage_Reg(
    input clk, rst, cache_freeze, flush,
    input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
    input B_IN, S_IN,
    input [3:0] EXE_CMD_IN,
    input [31:0] PC_IN,
    input [31:0] Val_Rn_IN, Val_Rm_IN,
    input imm_IN,
    input [11:0] Shift_operand_IN,
    input [23:0] Signed_imm_24_IN,
    input [3:0] Dest_IN,
    input [3:0] Src1_IN, Src2_IN,

    output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output reg [3:0] EXE_CMD,
    output reg [31:0] PC,
    output reg [31:0] Val_Rn, Val_Rm,
    output reg imm,
    output reg [11:0] Shift_operand,
    output reg [23:0] Signed_imm_24,
    output reg [3:0] Dest,
    output reg [3:0] Src1, Src2
    );

    always @(posedge clk, posedge rst) begin
        if (rst | flush) begin
            WB_EN <= 1'b0;
            MEM_R_EN <= 1'b0;
            MEM_W_EN <= 1'b0;
            B <= 1'b0;
            S <= 1'b0;
            EXE_CMD <= 4'b0;
            PC <= 32'b0;
            Val_Rn <= 32'b0;
            Val_Rm <= 32'b0;
            imm <= 1'b0;
            Shift_operand <= 12'b0;
            Signed_imm_24 <= 24'b0;
            Dest <= 4'b0;
            Src1 <= 4'b0;
            Src2 <= 4'b0;
        end
        else if (~cache_freeze) begin
            WB_EN <= WB_EN_IN;
            MEM_R_EN <= MEM_R_EN_IN;
            MEM_W_EN <= MEM_W_EN_IN;
            B <= B_IN;
            S <= S_IN;
            EXE_CMD <= EXE_CMD_IN;
            PC <= PC_IN;
            Val_Rn <= Val_Rn_IN;
            Val_Rm <= Val_Rm_IN;
            imm <= imm_IN;
            Shift_operand <= Shift_operand_IN;
            Signed_imm_24 <= Signed_imm_24_IN;
            Dest <= Dest_IN;
            Src1 <= Src1_IN;
            Src2 <= Src2_IN;
        end
    end
    
endmodule