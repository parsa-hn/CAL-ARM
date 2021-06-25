module SRAM_Controller(
    input clk, rst,
    input write_en, read_en,
    input [31:0] address, writeData,

    output reg [63:0] readData,
    output reg ready,
    
    inout [63:0] SRAM_DQ,
    output [16:0] SRAM_ADDR,
    output reg SRAM_WE_N, 
    output SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N
);

    parameter [2:0] idle = 3'd0, load = 3'd1, store = 3'd2, 
        wait1 = 3'd3, wait2 = 3'd4, wait3 = 3'd5, finish = 3'd6;
    reg [2:0] ps, ns;
    reg sram_load_en;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0;
    assign SRAM_DQ = SRAM_WE_N ? 64'bz : {32'b0, writeData};
    assign SRAM_ADDR = (address[16:0] - 17'd1024) >> 2;
    
    always @(ps, write_en, read_en) begin
        ns <= idle;
        
        case (ps)
            idle: begin 
                ns <= write_en ? store : read_en ? load : idle;
                SRAM_WE_N <= ~write_en;
                ready <= ~(write_en || read_en);
                sram_load_en <= read_en;
            end
            load: begin ns <= wait1; sram_load_en <= 1'b1; end
            store: begin ns <= wait1; SRAM_WE_N <= 1'b0; end
            wait1: ns <= wait2;
            wait2: ns <= wait3;
            wait3: ns <= finish;
            finish: begin ns <= idle; ready <= 1'b1; end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst) readData <= 64'b0;
        else if (sram_load_en) readData <= SRAM_DQ;
    end

    always @(posedge clk, posedge rst) begin
        if (rst) ps <= idle;
        else ps <= ns;
    end

endmodule