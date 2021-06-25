`timescale 1ns/1ns

module SRAM(
    input clk, rst,
    input SRAM_WE_N,
    input [16:0] SRAM_ADDR,
    inout [63:0] SRAM_DQ
);

    reg [31:0] memory [0:511];
    wire [16:0] first_address, second_address;
    integer i;

    assign first_address = {SRAM_ADDR[16:1], 1'b0};
    assign second_address = {SRAM_ADDR[16:1], 1'b1};
    assign #30 SRAM_DQ = SRAM_WE_N ? {memory[second_address], memory[first_address]} : 64'bz;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1) begin
                memory[i] <= i;
            end
        end
        else if (~SRAM_WE_N)
            memory[SRAM_ADDR] = SRAM_DQ[31:0];
    end

endmodule