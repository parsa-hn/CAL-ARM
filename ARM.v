module ARM(input clk, rst);
    reg freeze = 0, Branch_taken = 0, flush = 0;
    reg [31:0] BranchAddr = 32'b0;
    wire [31:0] Instruction, Instruction_in;
    wire [31:0] PC [0:9];

    //ID Stage
    wire ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, ID_imm, ID_Two_src;
    wire [3:0] ID_EXE_CMD, ID_Dest, ID_src1, ID_src2;
    wire [31:0] ID_Val_Rn, ID_Val_Rm;
    wire [11:0] ID_Shift_operand;
    wire [23:0] ID_Signed_imm_24;
    
    wire ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, ID_Reg_B, ID_Reg_S, ID_Reg_imm, ID_Reg_Two_src;
    wire [3:0] ID_Reg_EXE_CMD, ID_Reg_Dest, ID_Reg_src1, ID_Reg_src2;
    wire [31:0] ID_Reg_Val_Rn, ID_Reg_Val_Rm;
    wire [11:0] ID_Reg_Shift_operand;
    wire [23:0] ID_Reg_Signed_imm_24;

    IF_Stage if_stage(clk, rst, freeze, Branch_taken, BranchAddr, PC[0], Instruction_in);
    IF_Stage_Reg if_stage_reg(clk, rst, freeze, flush, PC[0], Instruction_in, PC[1], Instruction);

    ID_Stage id_stage(
        clk, rst, PC[1], Instruction, 32'b0, 1'b0, 4'b0, 1'b0, 4'b0,
        ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, 
        ID_EXE_CMD, ID_Val_Rn, ID_Val_Rm, PC[2], ID_imm, ID_Shift_operand,
        ID_Signed_imm_24, ID_Dest, ID_src1, ID_src2, ID_Two_src
    );
    ID_Stage_Reg id_stage_reg(
        clk, rst, flush, ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, ID_EXE_CMD, PC[2],
        ID_Val_Rn, ID_Val_Rm, ID_imm, ID_Shift_operand, ID_Signed_imm_24, ID_Dest,
        ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, ID_Reg_B, ID_Reg_S, ID_Reg_EXE_CMD, PC[3],
        ID_Reg_Val_Rn, ID_Reg_Val_Rm, ID_Reg_imm, ID_Reg_Shift_operand, ID_Reg_Signed_imm_24, ID_Reg_Dest,
    );

    EXE_Stage exe_stage(clk, rst, PC[3], PC[4]);
    EXE_Stage_Reg exe_stage_reg(clk, rst, PC[4], PC[5]);
    
    MEM_Stage mem_stage(clk, rst, PC[5], PC[6]);
    MEM_Stage_Reg mem_stage_reg(clk, rst, PC[6], PC[7]);

    WB_Stage wb_stage(clk, rst, PC[7], PC[8]);
    WB_Stage_Reg wb_stage_reg(clk, rst, PC[8], PC[9]);
    
endmodule