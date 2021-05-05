module EXE_Stage(
    input clk,
    input [3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input [31:0] PC, Val_Rn, Val_Rm,
    input imm,
    input [11:0] Shift_operand,
    input [23:0] Signed_imm_24,
    input [3:0] SR,
    output [31:0] ALU_result, Br_addr,
    output [3:0] status
);
	wire [31:0] Val_2;
	wire MEM_R_W;
	wire [31:0] imm2;	

	assign MEM_R_W = MEM_R_EN | MEM_W_EN;

	Val2_Generator Val2_Generator(Shift_operand, Val_Rm, MEM_R_W, imm, Val_2);
	ALU ALU(Val_Rn, Val_2, SR[1], EXE_CMD, ALU_result, status[3], status[2], status[1], status[0]);

    assign imm2 = {{6{Signed_imm_24[23]}}, Signed_imm_24, 2'b0};
    assign Br_addr = PC + imm2;
    
endmodule