module IF_Stage_Reg(
    input clk, rst, cache_freeze, freeze, flush,
    input [31:0] PC_in, Instruction_in,
    output reg [31:0] PC, Instruction
    );

	always@ (posedge clk, posedge rst) begin
		if (rst) begin
			PC <= 32'b0;
			Instruction <= 32'b0;
		end
		else if (flush) begin
		    Instruction <= 32'b0 ;
        end
		else if (~freeze && ~cache_freeze) begin
			Instruction <= Instruction_in;
			PC <= PC_in;
		end
	end
	
endmodule