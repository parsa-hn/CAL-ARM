module ID_Stage(
    input clk, rst,
    //from IF Reg
    input [31:0] PC_in, instruction,
    //from WB stage
    input [31 : 0] Result_WB,
    input writeBackEn,
    input [3:0] Dest_wb,
    //from hazard detect module
    input hazard,
    //from status register
    input [3:0] SR,
    //to next stage
    output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output [3:0] EXE_CMD,
    output [31:0] Val_Rn, Val_Rm,
    output [31:0] PC_out,
    output imm,
    output [11:0] Shift_operand,
    output [23:0] Signed_imm_24,
    output [3:0] Dest,
    //to hazard detect module
    output [3:0] src1, src2,
    output Two_src
    );

    wire CC_out, CU_mem_read, CU_mem_write, CU_wb_en, CU_S, CU_B;
	wire [3:0] CU_EXE_CMD;

    Condition_Check Condition_Check(SR[3], SR[2], SR[1], SR[0], instruction[31:28], CC_out);
    
	Control_Unit Control_Unit(
        instruction[27:26], instruction[24:21], instruction[20], 
        CU_EXE_CMD, CU_mem_read, CU_mem_write, CU_wb_en, CU_S, CU_B
        );
    assign WB_EN = ~((~CC_out) | hazard) ? CU_wb_en : 0;
	assign S = ~((~CC_out) | hazard) ? CU_S :0;
	assign B = ~((~CC_out) | hazard) ? CU_B : 0;
	assign MEM_R_EN = ~((~CC_out) | hazard) ? CU_mem_read : 0;
	assign MEM_W_EN = ~((~CC_out) | hazard) ? CU_mem_write : 0;
	assign EXE_CMD = ~((~CC_out) | hazard) ? CU_EXE_CMD : 0;
    
	assign src1 = instruction[19:16];
	assign src2 = (MEM_W_EN == 0) ? instruction[3:0] : instruction[15:12];
	Register_File Register_File(clk, rst, src1, src2, Dest_wb, Result_WB, writeBackEn, Val_Rn, Val_Rm);

	assign PC_out = PC_in;
	assign Shift_operand = instruction[11:0];
	assign imm = instruction[25];
	assign Dest = instruction[15:12];
	assign Signed_imm_24 = instruction[23:0];
	assign Two_src = (~imm) | MEM_W_EN;
	
endmodule