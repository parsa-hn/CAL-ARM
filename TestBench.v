`timescale 1ps/1ps

module TB();
    reg clk = 0, forward_en = 1;
    reg rst;

    initial begin
        rst = 1;
        #35 rst = 0;
        #15000
        $stop;
    end

    always #10 clk = ~clk;
    ARM arm(clk, rst, forward_en);

endmodule