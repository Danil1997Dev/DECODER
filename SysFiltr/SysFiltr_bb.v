
module SysFiltr (
	clk_clk,
	reset_reset_n,
	decoder_expend_signal_i,
	decoder_expend_indicate,
	decoder_expend_work);	

	input		clk_clk;
	input		reset_reset_n;
	input	[31:0]	decoder_expend_signal_i;
	output		decoder_expend_indicate;
	input		decoder_expend_work;
endmodule
