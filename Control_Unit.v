module Control_Unit(
    input [1:0] mode,
    input [3:0] op_code, 
    input S_in, 
    output reg [3:0] EXE_CMD, 
    output reg mem_read, mem_write, wb_en, S_out, B
    );

    always @(mode, op_code, S_in) begin
        EXE_CMD <= 0;
        mem_read <= 0;
        mem_write <= 0;
        wb_en <= 0;
        S_out <= 0;
        B <= 0;
		case ({mode, op_code})
            6'b000100: begin S_out <= S_in; EXE_CMD <= 4'b0000; wb_en <= 1'b1; end //ADD
            6'b000101: begin S_out <= S_in; EXE_CMD <= 4'b0001; wb_en <= 1'b1; end //ADC
            6'b000010: begin S_out <= S_in; EXE_CMD <= 4'b0010; wb_en <= 1'b1; end //SUB
            6'b000110: begin S_out <= S_in; EXE_CMD <= 4'b0011; wb_en <= 1'b1; end //SBC

            6'b000000: begin S_out <= S_in; EXE_CMD <= 4'b0100; wb_en <= 1'b1; end //AND
            6'b001100: begin S_out <= S_in; EXE_CMD <= 4'b0101; wb_en <= 1'b1; end //OR
            6'b000001: begin S_out <= S_in; EXE_CMD <= 4'b0110; wb_en <= 1'b1; end //XOR

            6'b001010: begin S_out <= 1'b1; EXE_CMD <= 4'b0111; wb_en <= 1'b1; end //CMP
            6'b001000: begin S_out <= 1'b1; EXE_CMD <= 4'b1000; wb_en <= 1'b1; end //TST

            6'b001101: begin S_out <= S_in; EXE_CMD <= 4'b1001; wb_en <= 1'b1; end //MOV
            6'b001111: begin S_out <= S_in; EXE_CMD <= 4'b1010; wb_en <= 1'b1; end //MVN

            6'b010100: 
                begin 
                    if (S_in) begin mem_read <= 1'b1; EXE_CMD <= 4'b1011; wb_en <= 1'b1; end //LDR
                    else begin mem_write <= 1'b1; EXE_CMD <= 4'b1100; end //STR
                end
		endcase
		if (mode == 2'b10) begin //B
			wb_en <= 1'b1; 
            B <= 1'b1; 
            EXE_CMD <= 4'bxxxx;
		end
    end
endmodule