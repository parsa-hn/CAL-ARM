module IF_Stage(
    input clk, rst, freeze, Branch_taken, 
    input [31:0] BranchAddr,
    output reg [31:0] PC,
    output [31:0] Instruction
    );
    wire [31:0] PC_in;
    Instruction_Memory Instruction_Memory(PC, Instruction);
    always @(posedge clk, posedge rst)
	begin
		if (rst)
			PC <= 32'b0;
		else if (freeze)
			PC <= PC_in;
		else
			PC <= PC_in + 32'd4;
	end

endmodule