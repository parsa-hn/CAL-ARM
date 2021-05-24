module ALU(
    input [31:0] Val1, Val2, 
    input C_in, 
    input [3:0] EXE_CMD, 
    output reg [31:0] final_output,
    output N_out, Z_out,
    output reg C_out, V_out
    );

    wire [31:0] ADD_output, ADC_output, SUB_output, SBC_output;
    wire ADD_C_out, ADC_C_out, SUB_C_out, SBC_C_out;
    wire ADD_V_out, ADC_V_out, SUB_V_out, SBC_V_out;

	assign {ADD_C_out, ADD_output} = Val1 + Val2 + 1'b0;
	assign ADD_V_out = ((~ADD_output[31]) & Val1[31] & Val2[31]) | 
                    (ADD_output[31] & (~Val1[31]) & (~Val2[31]));

	assign {ADC_C_out, ADC_output} = Val1 + Val2 + C_in;
	assign ADC_V_out = ((~ADC_output[31]) & Val1[31] & Val2[31]) | 
                    (ADC_output[31] & (~Val1[31]) & (~Val2[31]));

	assign {SUB_C_out, SUB_output} = Val1 - Val2 - 1'b0;
	assign SUB_V_out = ((~SUB_output[31]) & Val1[31] & (~Val2[31])) | 
                    (SUB_output[31] & (~Val1[31]) & (Val2[31]));

	assign {SBC_C_out, SBC_output} = Val1 - Val2 - !C_in;
	assign SBC_V_out = ((~SBC_output[31]) & Val1[31] & (~Val2[31])) | 
                    (SBC_output[31] & (~Val1[31]) & (Val2[31]));

    always @(Val1, Val2, EXE_CMD) begin
        C_out <= 0; 
        V_out <= 0;
        case(EXE_CMD)
            4'b0001: final_output <= Val2; //MOV
            4'b1001: final_output <= ~Val2; //MVN
            4'b0010: begin //ADD, LDR, STR
                final_output <= ADD_output;
                C_out <= ADD_C_out;
                V_out <= ADD_V_out; 
            end
            4'b0011: begin //ADC
                final_output <= ADC_output;
                C_out <= ADC_C_out;
                V_out <= ADC_V_out; 
            end
            4'b0100: begin //SUB, CMP
                final_output <= SUB_output;
                C_out <= SUB_C_out;
                V_out <= SUB_V_out; 
            end
            4'b0101: begin //SBC
                final_output <= SBC_output;
                C_out <= SBC_C_out;
                V_out <= SBC_V_out; 
            end
            4'b0110: final_output <= Val1 & Val2; //AND, TST
            4'b0111: final_output <= Val1 | Val2; //OR
            4'b1000: final_output <= Val1 ^ Val2; //EOR
        endcase
        if (V_out) C_out <= 0;
    end

    assign N_out = final_output[31];
    assign Z_out = (final_output == 0);
	
endmodule