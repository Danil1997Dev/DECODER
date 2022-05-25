// Quartus Prime Verilog Template
// Binary counter

module SUB_CNT
#(parameter WIDTH=64)
(
	input clk, valid, reset_l,cnt_en,
	input [WIDTH-1:0] count_input,count_gen,
	output logic signed [WIDTH+1:0] delta
);

	// Reset if needed, or increment if counting is enabled
	always_ff @ (posedge clk or negedge reset_l)
	begin
		if (!reset_l) begin
			delta <= 0; end
		else begin
			if (valid == 1'b1) 
				delta <= count_input - count_gen;
			else
				delta <= 0; 
	end end

endmodule
