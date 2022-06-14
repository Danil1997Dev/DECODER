	component SysFiltr is
		port (
			clk_clk                     : in  std_logic                     := 'X';             -- clk
			reset_reset_n               : in  std_logic                     := 'X';             -- reset_n
			decoder_expend_indicate     : out std_logic;                                        -- indicate
			decoder_expend_work         : in  std_logic                     := 'X';             -- work
			decoder_expend_signal_adc_i : in  std_logic_vector(13 downto 0) := (others => 'X'); -- signal_adc_i
			decoder_expend_signal_adc_u : in  std_logic_vector(13 downto 0) := (others => 'X')  -- signal_adc_u
		);
	end component SysFiltr;

	u0 : component SysFiltr
		port map (
			clk_clk                     => CONNECTED_TO_clk_clk,                     --            clk.clk
			reset_reset_n               => CONNECTED_TO_reset_reset_n,               --          reset.reset_n
			decoder_expend_indicate     => CONNECTED_TO_decoder_expend_indicate,     -- decoder_expend.indicate
			decoder_expend_work         => CONNECTED_TO_decoder_expend_work,         --               .work
			decoder_expend_signal_adc_i => CONNECTED_TO_decoder_expend_signal_adc_i, --               .signal_adc_i
			decoder_expend_signal_adc_u => CONNECTED_TO_decoder_expend_signal_adc_u  --               .signal_adc_u
		);

