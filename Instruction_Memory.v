module Instruction_Memory
	(
		input [31:0] PC, 
		output reg [31:0] Instruction
	);

	always @(PC) begin
		case(PC)			
			32'd0 : Instruction <= 32'b00000000001000100000000000000000;
			32'd4 : Instruction <= 32'b00000000011001000000000000000000;
			32'd8 : Instruction <= 32'b00000000101001100000000000000000;
			32'd12 : Instruction <= 32'b00000000111010001000000000000000;
			32'd16 : Instruction <= 32'b00000001001010100001100000000000;
			32'd20 : Instruction <= 32'b00000001011011000000000000000000;
		endcase
	end

endmodule