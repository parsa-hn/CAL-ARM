module Status_Register(
    input clk, rst, S, 
    input [3:0] status, 
    output reg [3:0] SR
    );
  
    always @(negedge clk, posedge rst) begin
		if (rst)
			SR <= 4'b0;
		else if (S)
			SR <= status;
		else
			SR <= SR;
    end

endmodule