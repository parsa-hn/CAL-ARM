module Memory(
    input clk, MEMread, MEMwrite,
    input [31:0] data, address,
    output reg [31:0] MEM_result
);

    reg [31:0] memory [0:63];
    wire [31:0] memory_address;
    
    assign memory_address = {address[31:2], 2'b0} - 32'd1024;
    
    always @(posedge clk) begin
        if (MEMwrite) memory[memory_address] <= data;
    end

    always @(*) begin
        if (MEMread == 1) MEM_result <= memory[memory_address];
        else if (MEMread == 0) MEM_result <= 32'b0;
    end

endmodule