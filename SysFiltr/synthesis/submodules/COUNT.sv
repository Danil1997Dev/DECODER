// Quartus Prime Verilog Template
// Binary counter

module COUNT
#(parameter WIDTH=64)
(
	input clk, enable, reset_l,cnt_en,
	output reg [WIDTH-1:0] count
);

	// Reset if needed, or increment if counting is enabled
	always_ff @ (posedge clk or negedge reset_l)
	begin
		if (!reset_l) begin
			count <= 0; end
		else begin
		      if (cnt_en == 1'b1) begin
			if (enable == 1'b1) 
				count <= count + 1;
			else
				count <= count; end
		else
		   count <= 0; end
	end

endmodule
