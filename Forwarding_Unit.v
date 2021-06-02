module Forwarding_Unit(
    input [3:0] EXE_src1, EXE_src2, MEM_DEST, Write_Back_DEST,
    input MEM_WB_EN, Write_Back_WB_EN, forward_en,
     
    output [1:0] Sel_src1, Sel_src2
);

    assign Sel_src1 = 
        (forward_en == 0) ? 2'b00 :
        ((EXE_src1 == MEM_DEST) && MEM_WB_EN == 1'b1) ? 2'b01 :
        ((EXE_src1 == Write_Back_DEST) && Write_Back_WB_EN == 1'b1) ? 2'b10 : 
        2'b00;

    assign Sel_src2 = 
        (forward_en == 0) ? 2'b00 :
        ((EXE_src2 == MEM_DEST) && MEM_WB_EN == 1'b1) ? 2'b01 :
        ((EXE_src2 == Write_Back_DEST) && Write_Back_WB_EN == 1'b1) ? 2'b10 : 
        2'b00;
     
endmodule