module Instruction_Memory
	(
		input [31:0] PC, 
		output reg [31:0] Instruction
	);

	always @(PC) begin
		case(PC)
			32'd0 : Instruction <= 32'b11100011101000000000000000010100; //MOV R0 ,#20 //R0 = 20
			32'd4 : Instruction <= 32'b11100011101000000001101000000001; //MOV R1 ,#4096 //R1 = 4096
			32'd8 : Instruction <= 32'b11100011101000000010000100000011; //MOV R2 ,#0xC0000000 //R2 = -1073741824
			32'd12 : Instruction <= 32'b11100000100100100011000000000010; //ADDS R3 ,R2,R2 //R3 = -2147483648
			32'd16 : Instruction <= 32'b11100000101000000100000000000000; //ADC R4 ,R0,R0 //R4 = 41
			32'd20 : Instruction <= 32'b11100000010001000101000100000100; //SUB R5 ,R4,R4,LSL #2 //R5 = -123
			32'd24 : Instruction <= 32'b11100000110000000110000010100000; //SBC R6 ,R0,R0,LSR #1 //R6 = 10
			32'd28 : Instruction <= 32'b11100001100001010111000101000010; //ORR R7 ,R5,R2,ASR #2 //R7 = -123
			32'd32 : Instruction <= 32'b11100000000001111000000000000011; //AND R8 ,R7,R3 //R8 = -2147483648
			32'd36 : Instruction <= 32'b11100001111000001001000000000110; //MVN R9 ,R6 //R9 = -11
			32'd40 : Instruction <= 32'b11100000001001001010000000000101; //EOR R10,R4,R5 //R10 = -84
			32'd44 : Instruction <= 32'b11100001010110000000000000000110; //CMP R8 ,R6
			32'd48 : Instruction <= 32'b00010000100000010001000000000001; //ADDNE R1 ,R1,R1 //R1 = 8192
			32'd52 : Instruction <= 32'b11100001000110010000000000001000; //TST R9 ,R8
			32'd56 : Instruction <= 32'b00000000100000100010000000000010; //ADDEQ R2 ,R2,R2 //R2 = -1073741824
			32'd60 : Instruction <= 32'b11100011101000000000101100000001; //MOV R0 ,#1024 //R0 = 1024
			32'd64 : Instruction <= 32'b11100100100000000001000000000000; //STR R1 ,[R0],#0 //MEM[1024] = 8192
			32'd68 : Instruction <= 32'b11100100100100001011000000000000; //LDR R11,[R0],#0 //R11 = 8192
		endcase
	end

endmodule