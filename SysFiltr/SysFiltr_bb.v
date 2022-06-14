
module SysFiltr (
	clk_clk,
	reset_reset_n,
	decoder_expend_indicate,
	decoder_expend_work,
	decoder_expend_signal_adc_i,
	decoder_expend_signal_adc_u);	

	input		clk_clk;
	input		reset_reset_n;
	output		decoder_expend_indicate;
	input		decoder_expend_work;
	input	[13:0]	decoder_expend_signal_adc_i;
	input	[13:0]	decoder_expend_signal_adc_u;
endmodule
