module Val2_Generator(
    input [11:0] shift_operand,
    input [31:0] val_rm,
    input MEM_R_W, imm,
    output reg [31:0] val_out
    );

    wire [31:0] extended_imm;
    wire [63:0] shifted_64bit_imm, shifted_64bit_val_rm;

    assign extended_imm = {24'b0, shift_operand[7:0]};
    assign shifted_64bit_imm = ({extended_imm, extended_imm} >> {shift_operand[11:8], 1'b0});
    assign shifted_64bit_val_rm = ({val_rm, val_rm} >> shift_operand[11:7]);

    always @(*) begin
        if (MEM_R_W)
            val_out = {{20{shift_operand[11]}}, shift_operand};
        else if (imm) begin  //32-bit immediate
            val_out = shifted_64bit_imm[31:0];
        end
        else if (~shift_operand[4]) begin
            case(shift_operand[6:5])
                2'b00: val_out = val_rm << shift_operand[11:7]; //LSL
                2'b01: val_out = val_rm >> shift_operand[11:7]; //LSR
                2'b10: val_out = val_rm >>> shift_operand[11:7]; //ASR
                2'b11: val_out = shifted_64bit_val_rm[31:0]; //ROR
            endcase
        end
    end

endmodule