	SysFiltr u0 (
		.clk_clk                     (<connected-to-clk_clk>),                     //            clk.clk
		.reset_reset_n               (<connected-to-reset_reset_n>),               //          reset.reset_n
		.decoder_expend_indicate     (<connected-to-decoder_expend_indicate>),     // decoder_expend.indicate
		.decoder_expend_work         (<connected-to-decoder_expend_work>),         //               .work
		.decoder_expend_signal_adc_i (<connected-to-decoder_expend_signal_adc_i>), //               .signal_adc_i
		.decoder_expend_signal_adc_u (<connected-to-decoder_expend_signal_adc_u>)  //               .signal_adc_u
	);

