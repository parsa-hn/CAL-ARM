module ARM(input clk, rst);
    reg freeze = 0, Branch_taken = 0, flush = 0;
    reg [31:0] BranchAddr = 32'b0;
    wire [31:0] Instruction, Instruction_in;
    wire [31:0] PC [0:8];

    //ID Stage wires
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

    //EXE Stage wires
    wire [31:0] EXE_ALU_result, EXE_Br_addr;
    wire [3:0] EXE_status, SR;

    wire Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN;
    wire [31:0] EXE_Reg_ALU_result, Exe_Reg_Val_Rm;
    wire [3:0] Exe_Reg_Dest;

    //WB Stage wires
    wire [31:0] WB_Value;

    //MEM Stage wires
    wire MEM_Reg_WB_en, MEM_Reg_MEM_R_en;
    wire [31:0] MEM_Reg_ALU_result, MEM_Reg_Mem_read_value;
    wire [3:0] MEM_Reg_Dest;

    //IF Stage
    IF_Stage if_stage(clk, rst, freeze, Branch_taken, BranchAddr, PC[0], Instruction_in);
    IF_Stage_Reg if_stage_reg(clk, rst, freeze, flush, PC[0], Instruction_in, PC[1], Instruction);

    //ID Stage
    ID_Stage id_stage(
        clk, rst, PC[1], Instruction, WB_Value, MEM_Reg_WB_en, MEM_Reg_Dest, 1'b0, SR,
        ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, 
        ID_EXE_CMD, ID_Val_Rn, ID_Val_Rm, PC[2], ID_imm, ID_Shift_operand,
        ID_Signed_imm_24, ID_Dest, ID_src1, ID_src2, ID_Two_src
    );
    ID_Stage_Reg id_stage_reg(
        clk, rst, flush, ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, ID_EXE_CMD, PC[2],
        ID_Val_Rn, ID_Val_Rm, ID_imm, ID_Shift_operand, ID_Signed_imm_24, ID_Dest,
        ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, ID_Reg_B, ID_Reg_S, ID_Reg_EXE_CMD, PC[3],
        ID_Reg_Val_Rn, ID_Reg_Val_Rm, ID_Reg_imm, ID_Reg_Shift_operand, ID_Reg_Signed_imm_24, ID_Reg_Dest
    );

    //EXE Stage
    Status_Register status_register(
        clk, rst, ID_Reg_S, EXE_status, SR
    );
    EXE_Stage exe_stage(
        clk, ID_Reg_EXE_CMD, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, PC[3], ID_Reg_Val_Rn, ID_Reg_Val_Rm,
        ID_Reg_imm, ID_Reg_Shift_operand, ID_Reg_Signed_imm_24, SR,
        EXE_ALU_result, EXE_Br_addr, EXE_status
    );
    EXE_Stage_Reg exe_stage_reg(
        clk, rst, ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, EXE_ALU_result, ID_Reg_Val_Rm, ID_Reg_Dest,
        Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN, EXE_Reg_ALU_result, Exe_Reg_Val_Rm, Exe_Reg_Dest
    );
    
    //MEM Stage
    MEM_Stage mem_stage(clk, rst, PC[5], PC[6]);
    MEM_Stage_Reg mem_stage_reg(
        clk, rst, Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, EXE_Reg_ALU_result, 32'b0, Exe_Reg_Dest,
        MEM_Reg_WB_en, MEM_Reg_MEM_R_en, MEM_Reg_ALU_result, MEM_Reg_Mem_read_value, MEM_Reg_Dest
    );

    //WB Stage
    WB_Stage wb_stage(
        MEM_Reg_ALU_result, MEM_Reg_Mem_read_value, MEM_Reg_MEM_R_en,
        WB_Value
    );
    
endmodule