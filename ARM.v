module ARM(
    input clk, rst, forward_en,
    output SRAM_WE_N, 
    output [16:0] SRAM_ADDR, 
    inout [63:0] SRAM_DQ
);

    wire [31:0] Instruction, Instruction_in, branch_address;
    wire [31:0] PC [0:8];
    wire hazard, flush, freeze, branch_taken;

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
    wire [31:0] EXE_ALU_result, EXE_Br_addr, Exe_Src2_mux_out;
    wire [3:0] EXE_status, SR;

    wire Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN;
    wire [31:0] EXE_Reg_ALU_result, Exe_Reg_Val_Rm;
    wire [3:0] Exe_Reg_Dest;

    //WB Stage wires
    wire [31:0] WB_Value;

    //MEM Stage wires
    wire [31:0] MEM_result;

    wire MEM_Reg_WB_en, MEM_Reg_MEM_R_en;
    wire [31:0] MEM_Reg_ALU_result, MEM_Reg_Mem_read_value;
    wire [3:0] MEM_Reg_Dest;

    wire cache_freeze;
    wire sram_ctrl_ready, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N;
    wire [63:0] sram_ctrl_readData;

    wire [31:0] cache_r_data, cache_sram_address, cache_sram_wdata;
    wire cache_ready, cache_sram_read, cache_sram_write;

    //Forwarding unit wires
    wire [1:0] FU_Sel_src1, FU_Sel_src2;


    //------------ Modules ------------


    assign freeze = hazard;
    assign branch_taken = ID_Reg_B;
    assign flush = branch_taken;
    assign branch_address = EXE_Br_addr;
    assign cache_freeze = ~cache_ready;

    //Hazard Detection
    Hazard_Detection_Unit hazard_detection_unit(
        ID_src1, ID_src2, ID_Reg_Dest, ID_Reg_WB_EN, Exe_Reg_Dest, Exe_Reg_WB_EN, ID_Two_src, forward_en,
        hazard
    );

    //Forwarding Unit
    Forwarding_Unit forwarding_unit(
        ID_Reg_src1, ID_Reg_src2, Exe_Reg_Dest, MEM_Reg_Dest, Exe_Reg_WB_EN, MEM_Reg_WB_en, forward_en,
        FU_Sel_src1, FU_Sel_src2
    );

    //IF Stage
    IF_Stage if_stage(clk, rst, cache_freeze, freeze, branch_taken, branch_address, PC[0], Instruction_in);
    IF_Stage_Reg if_stage_reg(clk, rst, cache_freeze, freeze, flush, PC[0], Instruction_in, PC[1], Instruction);

    //ID Stage
    ID_Stage id_stage(
        clk, rst, PC[1], Instruction, WB_Value, MEM_Reg_WB_en, MEM_Reg_Dest, hazard, SR,
        ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, 
        ID_EXE_CMD, ID_Val_Rn, ID_Val_Rm, PC[2], ID_imm, ID_Shift_operand,
        ID_Signed_imm_24, ID_Dest, ID_src1, ID_src2, ID_Two_src
    );
    ID_Stage_Reg id_stage_reg(
        clk, rst, cache_freeze, flush, ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, ID_EXE_CMD, PC[2],
        ID_Val_Rn, ID_Val_Rm, ID_imm, ID_Shift_operand, ID_Signed_imm_24, ID_Dest, 
        ID_src1, ID_src2,
        ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, ID_Reg_B, ID_Reg_S, ID_Reg_EXE_CMD, PC[3],
        ID_Reg_Val_Rn, ID_Reg_Val_Rm, ID_Reg_imm, ID_Reg_Shift_operand, ID_Reg_Signed_imm_24, ID_Reg_Dest,
        ID_Reg_src1, ID_Reg_src2
    );

    //EXE Stage
    Status_Register status_register(
        clk, rst, ID_Reg_S, EXE_status, SR
    );
    EXE_Stage exe_stage(
        clk, ID_Reg_EXE_CMD, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, PC[3], ID_Reg_Val_Rn, ID_Reg_Val_Rm,
        ID_Reg_imm, ID_Reg_Shift_operand, ID_Reg_Signed_imm_24, SR,
        FU_Sel_src1, FU_Sel_src2, EXE_Reg_ALU_result, WB_Value,
        EXE_ALU_result, EXE_Br_addr, EXE_status, Exe_Src2_mux_out
    );
    EXE_Stage_Reg exe_stage_reg(
        clk, rst, cache_freeze, ID_Reg_WB_EN, ID_Reg_MEM_R_EN, ID_Reg_MEM_W_EN, EXE_ALU_result, Exe_Src2_mux_out, ID_Reg_Dest,
        Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN, EXE_Reg_ALU_result, Exe_Reg_Val_Rm, Exe_Reg_Dest
    );
    
    //MEM Stage
    Cache_Controller cache_controller(
        clk, rst, EXE_Reg_ALU_result, Exe_Reg_Val_Rm, Exe_Reg_MEM_R_EN, Exe_Reg_MEM_W_EN,
        cache_r_data, cache_ready, cache_sram_address, cache_sram_wdata, cache_sram_read, cache_sram_write,
        sram_ctrl_readData, sram_ctrl_ready
    );
    SRAM_Controller sram_controller(
        clk, rst, cache_sram_write, cache_sram_read, cache_sram_address, cache_sram_wdata,
        sram_ctrl_readData, sram_ctrl_ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N
    );
    MEM_Stage_Reg mem_stage_reg(
        clk, rst, cache_freeze, Exe_Reg_WB_EN, Exe_Reg_MEM_R_EN, EXE_Reg_ALU_result, cache_r_data, Exe_Reg_Dest,
        MEM_Reg_WB_en, MEM_Reg_MEM_R_en, MEM_Reg_ALU_result, MEM_Reg_Mem_read_value, MEM_Reg_Dest
    );

    //WB Stage
    WB_Stage wb_stage(
        MEM_Reg_ALU_result, MEM_Reg_Mem_read_value, MEM_Reg_MEM_R_en,
        WB_Value
    );
    
endmodule