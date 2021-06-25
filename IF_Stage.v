module IF_Stage(
    input clk, rst, cache_freeze, freeze, Branch_taken, 
    input [31:0] BranchAddr,
    output [31:0] PC,
    output [31:0] Instruction
);

    wire [31:0] PC_Reg_in, PC_Reg_out;
    assign PC_Reg_in = Branch_taken ? BranchAddr : PC;
    assign PC = PC_Reg_out + 32'd4;

    Instruction_Memory Instruction_Memory(PC_Reg_out, Instruction);
    PC_Reg PC_Reg(clk, rst, cache_freeze, freeze, PC_Reg_in, PC_Reg_out);

endmodule