module ARM(input clk, rst);
    reg freeze = 0, Branch_taken = 0, flush = 0;
    reg [31:0] BranchAddr = 32'd0;
    wire [31:0] Instruction, Instruction_in;
    wire [31:0] PC [0:9];

    IF_Stage if_stage(clk, rst, freeze, Branch_taken, BranchAddr, PC[0], Instruction_in);
    IF_Stage_Reg if_stage_reg(clk, rst, freeze, flush, PC[0], Instruction_in, PC[1], Instruction);

    ID_Stage id_stage(clk, rst, PC[1], PC[2]);
    ID_Stage_Reg id_stage_reg(clk, rst, PC[2], PC[3]);

    EXE_Stage exe_stage(clk, rst, PC[3], PC[4]);
    EXE_Stage_Reg exe_stage_reg(clk, rst, PC[4], PC[5]);
    
    MEM_Stage mem_stage(clk, rst, PC[5], PC[6]);
    MEM_Stage_Reg mem_stage_reg(clk, rst, PC[6], PC[7]);

    WB_Stage wb_stage(clk, rst, PC[7], PC[8]);
    WB_Stage_Reg wb_stage_reg(clk, rst, PC[8], PC[9]);
    
endmodule