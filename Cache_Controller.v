module Cache_Controller(
    input clk, rst,

    //memory stage unit
    input [31:0] address, wdata,
    input MEM_R_EN, MEM_W_EN,

    output [31:0] rdata,
    output reg ready,

    //SRAM controller
    output reg [31:0] sram_address, sram_wdata,
    output reg sram_read, sram_write,
    
    input [63:0] sram_rdata,
    input sram_ready
);

    reg [63:0] way0 [0:63];
    reg [63:0] way1 [0:63];
    reg [0:0] valid0 [0:63];
    reg [0:0] valid1 [0:63];
    reg [9:0] tag0 [0:63];
    reg [9:0] tag1 [0:63];
    reg [0:0] LRU [0:63]; //Least Recently Used
    wire offset, hit, hit0, hit1;
    reg cacheUsed, sram_block_read, secondWordLoaded, cacheDataInvalid;
    wire [5:0] index;
    wire [9:0] tag;
    wire [63:0] dataBlock;
    reg [1:0] ps, ns;
    parameter [1:0] idle = 2'd0, read = 2'd1, readSecondWord = 2'd2, write = 2'd3;
    
    //Cache memory
    integer i;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for(i = 0; i < 64; i = i + 1) begin
                way0[i] <= 64'b0;
                way1[i] <= 64'b0;
                valid0[i] <= 1'b0;
                valid1[i] <= 1'b0;
                tag0[i] <= 10'b0;
                tag1[i] <= 10'b0;
                LRU[i] <= 1'b0;
            end
        end
        else begin
            if (cacheUsed) begin
                if (hit0) LRU[index] <= 1'b1;
                else if (hit1) LRU[index] <= 1'b0;
            end
            if (sram_block_read) begin
                if (LRU[index] == 1'b0) begin
                    way0[index] <= sram_rdata;
                    tag0[index] <= tag; 
                    valid0[index] <= 1'b1;
                end
                if (LRU[index] == 1'b1) begin
                    way1[index] <= sram_rdata;
                    tag1[index] <= tag; 
                    valid1[index] <= 1'b1;
                end
            end
            if (cacheDataInvalid) begin
                if (hit0 == 1'b1) begin
                    valid0[index] <= 1'b0; 
                    LRU[index] <= 1'b0; 
                end
                else if (hit1 == 1'b1) begin
                    valid1[index] <= 1'b0; 
                    LRU[index] <= 1'b1; 
                end
            end
        end
    end

    // 1024 = 10_000000_000        ?= 11_000000_000
    // 1028 = 10_000000_100
    // 1032 = 10_000001_000
    // 1036 = 10_000001_100

    //Cache controller
    assign offset = address[2];
    assign index = address[8:3];
    assign tag = address[18:9];
    assign hit0 = valid0[index] && (tag == tag0[index]);
    assign hit1 = valid1[index] && (tag == tag1[index]);
    assign hit = hit0 || hit1;
    assign dataBlock = hit0 ? way0[index] : hit1 ? way1[index] : 64'b0;
    assign rdata = offset ? dataBlock[63:32] : dataBlock[31:0];

    //SRAM interface
    always @(ps, MEM_R_EN, MEM_W_EN, hit, sram_ready) begin
        ns <= idle;
        sram_wdata <= wdata;
        sram_address <= address;
        {sram_read, sram_write, ready, cacheUsed, sram_block_read, cacheDataInvalid} <= 6'b0;

        case(ps)
            idle: begin 
                ns <= MEM_W_EN ? write : (MEM_R_EN && ~hit) ? read : idle; 
                ready <= ~(MEM_W_EN || (MEM_R_EN && ~hit)); 
                cacheUsed <= (MEM_R_EN && hit); 
                end
            read: begin 
                ns <= sram_ready ? idle : read; 
                sram_read <= 1'b1; 
                sram_block_read <= sram_ready; 
                end
            write: begin 
                ns <= sram_ready ? idle : write; 
                sram_write <= 1'b1;
                cacheDataInvalid <= hit;
                ready <= sram_ready;
                end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst) ps <= idle;
        else ps <= ns;
    end

endmodule