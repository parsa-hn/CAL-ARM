module Hazard_Detection_Unit(
    input [3:0] src1, src2, Exe_Dest,
	input Exe_WB_EN,
	input [3:0] Mem_Dest,
    input Mem_WB_EN,
	input two_src,
	input forward_en,
    output hazard
);
    wire exe_hazard_one_src, exe_hazard_two_src;
	wire mem_hazard_one_src, mem_hazard_two_src;
	
	assign exe_hazard_one_src = Exe_WB_EN ? (src1 == Exe_Dest) : 0;
	assign exe_hazard_two_src = (Exe_WB_EN & two_src) ? (src2 == Exe_Dest) : 0;
	assign mem_hazard_one_src = Mem_WB_EN ? (src1 == Mem_Dest) : 0;
	assign mem_hazard_two_src = (Mem_WB_EN & two_src) ? (src2 == Mem_Dest) : 0;
	assign hazard = forward_en ? 0 :
					exe_hazard_one_src | exe_hazard_two_src | mem_hazard_one_src | mem_hazard_two_src;
endmodule