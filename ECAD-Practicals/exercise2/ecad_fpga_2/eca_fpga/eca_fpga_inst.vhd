	component eca_fpga is
		port (
			clk_clk                             : in  std_logic := 'X'; -- clk
			reset_reset_n                       : in  std_logic := 'X'; -- reset_n
			rotaryctl_0_rotary_event_rotary_cw  : out std_logic;        -- rotary_cw
			rotaryctl_0_rotary_event_rotary_ccw : out std_logic         -- rotary_ccw
		);
	end component eca_fpga;

	u0 : component eca_fpga
		port map (
			clk_clk                             => CONNECTED_TO_clk_clk,                             --                      clk.clk
			reset_reset_n                       => CONNECTED_TO_reset_reset_n,                       --                    reset.reset_n
			rotaryctl_0_rotary_event_rotary_cw  => CONNECTED_TO_rotaryctl_0_rotary_event_rotary_cw,  -- rotaryctl_0_rotary_event.rotary_cw
			rotaryctl_0_rotary_event_rotary_ccw => CONNECTED_TO_rotaryctl_0_rotary_event_rotary_ccw  --                         .rotary_ccw
		);

