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
			32'd72 : Instruction <= 32'b11100100100000000010000000000100; //STR R2 ,[R0],#4 //MEM[1028] = -1073741824
			32'd76 : Instruction <= 32'b11100100100000000011000000001000; //STR R3 ,[R0],#8 //MEM[1032] = -2147483648
			32'd80 : Instruction <= 32'b11100100100000000100000000001101; //STR R4 ,[R0],#13 //MEM[1036] = 41
			32'd84 : Instruction <= 32'b11100100100000000101000000010000; //STR R5 ,[R0],#16 //MEM[1040] = -123
			32'd88 : Instruction <= 32'b11100100100000000110000000010100; //STR R6 ,[R0],#20 //MEM[1044] = 10
			32'd92 : Instruction <= 32'b11100100100100001010000000000100; //LDR R10,[R0],#4 //R10 = -1073741824
			32'd96 : Instruction <= 32'b11100100100000000111000000011000; //STR R7 ,[R0],#24 //MEM[1048] = -123
			32'd100 : Instruction <= 32'b11100011101000000001000000000100; //MOV R1 ,#4 //R1 = 4
			32'd104 : Instruction <= 32'b11100011101000000010000000000000; //MOV R2 ,#0 //R2 = 0
			32'd108 : Instruction <= 32'b11100011101000000011000000000000; //MOV R3 ,#0 //R3 = 0
			32'd112 : Instruction <= 32'b11100000100000000100000100000011; //ADD R4 ,R0,R3,LSL #2 //R4 = 1024
			32'd116 : Instruction <= 32'b11100100100101000101000000000000; //LDR R5 ,[R4],#0 //R5 = 8192
			32'd120 : Instruction <= 32'b11100100100101000110000000000100; //LDR R6 ,[R4],#4 //R6 = -1073741824
			32'd124 : Instruction <= 32'b11100001010101010000000000000110; //CMP R5 ,R6
			32'd128 : Instruction <= 32'b11000100100001000110000000000000; //STRGT R6 ,[R4],#0 //MEM[1024] = -1073741824
			32'd132 : Instruction <= 32'b11000100100001000101000000000100; //STRGT R5 ,[R4],#4 //MEM[1028] = 8192
			32'd136 : Instruction <= 32'b11100010100000110011000000000001; //ADD R3 ,R3,#1 //
			32'd140 : Instruction <= 32'b11100011010100110000000000000011; //CMP R3 ,#3
			32'd144 : Instruction <= 32'b10111010111111111111111111110111; //BLT #-9
			32'd148 : Instruction <= 32'b11100010100000100010000000000001; //ADD R2 ,R2,#1
			32'd152 : Instruction <= 32'b11100001010100100000000000000001; //CMP R2 ,R1
			32'd156 : Instruction <= 32'b10111010111111111111111111110011; //BLT #-13
			32'd160 : Instruction <= 32'b11100100100100000001000000000000; //LDR R1 ,[R0],#0 //R1 = -2147483648
			32'd164 : Instruction <= 32'b11100100100100000010000000000100; //LDR R2 ,[R0],#4 //R2 = -1073741824
			32'd168 : Instruction <= 32'b11100100100100000011000000001000; //STR R3 ,[R0],#8 //R3 = 41
			32'd172 : Instruction <= 32'b11100100100100000100000000001100; //STR R4 ,[R0],#12 //R4 = 8192
			32'd176 : Instruction <= 32'b11100100100100000101000000010000; //STR R5 ,[R0],#16 //R5 = -123
			32'd180 : Instruction <= 32'b11100100100100000110000000010100; //STR R6 ,[R0],#20 //R4 = 10
			32'd184 : Instruction <= 32'b11101010111111111111111111111111; //B #-1
		endcase
	end

endmodule