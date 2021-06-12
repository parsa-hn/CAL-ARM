`timescale 1ns/1ns

module TB();
    reg clk = 0, sram_clk = 0, forward_en = 1;
    reg rst;
    wire SRAM_WE_N;
    wire [16:0] SRAM_ADDR;
    wire [31:0] SRAM_DQ;

    initial begin
        rst = 1;
        #35 rst = 0;
        #20000
        $stop;
    end

    always #20 clk = ~clk;
    always #40 sram_clk = ~sram_clk;

    ARM arm(clk, rst, forward_en, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);
    SRAM sram(sram_clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);

endmodule