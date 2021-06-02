module EXE_Stage(
    input clk,
    input [3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input [31:0] PC, Val_Rn, Val_Rm,
    input imm,
    input [11:0] Shift_operand,
    input [23:0] Signed_imm_24,
    input [3:0] SR,
    input [1:0] Sel_src1, Sel_src2,
    input [31:0] MEM_ALU_result, WB_Value,

    output [31:0] ALU_result, Br_addr,
    output [3:0] status,
    output [31:0] Src2_mux_out
);
	wire [31:0] Val_2;
	wire MEM_R_W;
	wire [31:0] imm2;
    wire [31:0] Src1_mux_out;

	assign MEM_R_W = MEM_R_EN | MEM_W_EN;

	Val2_Generator Val2_Generator(Shift_operand, Src2_mux_out, MEM_R_W, imm, Val_2);
	ALU ALU(Src1_mux_out, Val_2, SR[1], EXE_CMD, ALU_result, status[3], status[2], status[1], status[0]);

    assign imm2 = {{6{Signed_imm_24[23]}}, Signed_imm_24, 2'b0};
    assign Br_addr = PC + imm2;

    assign Src1_mux_out = (Sel_src1 == 2'b00) ? Val_Rn :
                          (Sel_src1 == 2'b01) ? MEM_ALU_result : WB_Value;
    assign Src2_mux_out = (Sel_src2 == 2'b00) ? Val_Rm :
                          (Sel_src2 == 2'b01) ? MEM_ALU_result : WB_Value;
endmodule