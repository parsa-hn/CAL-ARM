module WB_Stage(
    input [31:0] ALU_result, MEM_result,
    input MEM_R_EN,
    output [31:0] Write_value
);
    assign Write_value = MEM_R_EN ? ALU_result : MEM_result;
endmodule