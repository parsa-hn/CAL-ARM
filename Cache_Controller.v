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
    
    input [31:0] sram_rdata,
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
    reg cacheUsed, firstWordLoaded, secondWordLoaded, cacheDataInvalid;
    wire [5:0] index;
    wire [9:0] tag;
    wire [63:0] dataBlock;
    reg [1:0] ps, ns;
    parameter [1:0] idle = 2'd0, readFirstWord = 2'd1, readSecondWord = 2'd2, write = 2'd3;
    
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
        else if (cacheUsed) begin
            if (hit0) LRU[index] <= 1'b1;
            else if (hit1) LRU[index] <= 1'b0;
        end
        else if (firstWordLoaded) begin
            if (LRU[index] == 1'b0) begin
                if (offset == 1'b0) way0[index][31:0] <= sram_rdata;
                else if (offset == 1'b1) way0[index][63:32] <= sram_rdata;
            end
            if (LRU[index] == 1'b1) begin
                if (offset == 1'b0) way1[index][31:0] <= sram_rdata;
                else if (offset == 1'b1) way1[index][63:32] <= sram_rdata;
            end
        end
        else if (secondWordLoaded) begin
            if (LRU[index] == 1'b0) begin
                if (offset == 1'b0) way0[index][31:0] <= sram_rdata;
                else if (offset == 1'b1) way0[index][63:32] <= sram_rdata;
                tag0[index] <= tag; 
                valid0[index] <= 1'b1;
            end
            if (LRU[index] == 1'b1) begin
                if (offset == 1'b0) way1[index][31:0] <= sram_rdata;
                else if (offset == 1'b1) way1[index][63:32] <= sram_rdata;
                tag1[index] <= tag; 
                valid1[index] <= 1'b1;
            end
        end
        else if (cacheDataInvalid) begin
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
        {sram_read, sram_write, ready, cacheUsed, firstWordLoaded, secondWordLoaded, cacheDataInvalid} <= 7'b0;

        case(ps)
            idle: begin 
                ns <= MEM_W_EN ? write : (MEM_R_EN && ~hit) ? readFirstWord : idle; 
                ready <= ~(MEM_W_EN || (MEM_R_EN && ~hit)); 
                cacheUsed <= (MEM_R_EN && hit); 
                end
            readFirstWord: begin 
                ns <= sram_ready ? readSecondWord : readFirstWord; 
                sram_read <= 1'b1; 
                sram_address <= address;
                firstWordLoaded <= sram_ready; 
                end
            readSecondWord: begin 
                ns <= sram_ready ? idle : readSecondWord; 
                sram_read <= 1'b1;
                sram_address <= {address[31:3], ~address[2], address[1:0]};
                secondWordLoaded <= sram_ready; 
                ready <= sram_ready; 
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