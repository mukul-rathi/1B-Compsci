	component clarvi_soc is
		port (
			clk_clk                                   : in  std_logic                    := 'X';             -- clk
			eightbitstosevenseg_0_led_pins_led0       : out std_logic_vector(6 downto 0);                    -- led0
			eightbitstosevenseg_0_led_pins_led1       : out std_logic_vector(6 downto 0);                    -- led1
			eightbitstosevenseg_1_led_pins_led0       : out std_logic_vector(6 downto 0);                    -- led0
			eightbitstosevenseg_1_led_pins_led1       : out std_logic_vector(6 downto 0);                    -- led1
			eightbitstosevenseg_2_led_pins_led0       : out std_logic_vector(6 downto 0);                    -- led0
			eightbitstosevenseg_2_led_pins_led1       : out std_logic_vector(6 downto 0);                    -- led1
			leds_external_connection_export           : out std_logic_vector(9 downto 0);                    -- export
			pixelstream_0_conduit_end_0_lcd_red       : out std_logic_vector(7 downto 0);                    -- lcd_red
			pixelstream_0_conduit_end_0_lcd_green     : out std_logic_vector(7 downto 0);                    -- lcd_green
			pixelstream_0_conduit_end_0_lcd_blue      : out std_logic_vector(7 downto 0);                    -- lcd_blue
			pixelstream_0_conduit_end_0_lcd_hsync     : out std_logic;                                       -- lcd_hsync
			pixelstream_0_conduit_end_0_lcd_vsync     : out std_logic;                                       -- lcd_vsync
			pixelstream_0_conduit_end_0_lcd_de        : out std_logic;                                       -- lcd_de
			pixelstream_0_conduit_end_0_lcd_dclk      : out std_logic;                                       -- lcd_dclk
			pixelstream_0_conduit_end_0_lcd_dclk_en   : out std_logic;                                       -- lcd_dclk_en
			reset_reset_n                             : in  std_logic                    := 'X';             -- reset_n
			shiftregctl_0_shiftreg_ext_shiftreg_clk   : out std_logic;                                       -- shiftreg_clk
			shiftregctl_0_shiftreg_ext_shiftreg_loadn : out std_logic;                                       -- shiftreg_loadn
			shiftregctl_0_shiftreg_ext_shiftreg_out   : in  std_logic                    := 'X';             -- shiftreg_out
			rotaryctl_right_rotary_event_rotary_cw    : out std_logic;                                       -- rotary_cw
			rotaryctl_right_rotary_event_rotary_ccw   : out std_logic;                                       -- rotary_ccw
			rotaryctl_right_rotary_in_rotary_in       : in  std_logic_vector(1 downto 0) := (others => 'X'); -- rotary_in
			rotaryctl_left_rotary_event_rotary_cw     : out std_logic;                                       -- rotary_cw
			rotaryctl_left_rotary_event_rotary_ccw    : out std_logic;                                       -- rotary_ccw
			rotaryctl_left_rotary_in_rotary_in        : in  std_logic_vector(1 downto 0) := (others => 'X')  -- rotary_in
		);
	end component clarvi_soc;

	u0 : component clarvi_soc
		port map (
			clk_clk                                   => CONNECTED_TO_clk_clk,                                   --                            clk.clk
			eightbitstosevenseg_0_led_pins_led0       => CONNECTED_TO_eightbitstosevenseg_0_led_pins_led0,       -- eightbitstosevenseg_0_led_pins.led0
			eightbitstosevenseg_0_led_pins_led1       => CONNECTED_TO_eightbitstosevenseg_0_led_pins_led1,       --                               .led1
			eightbitstosevenseg_1_led_pins_led0       => CONNECTED_TO_eightbitstosevenseg_1_led_pins_led0,       -- eightbitstosevenseg_1_led_pins.led0
			eightbitstosevenseg_1_led_pins_led1       => CONNECTED_TO_eightbitstosevenseg_1_led_pins_led1,       --                               .led1
			eightbitstosevenseg_2_led_pins_led0       => CONNECTED_TO_eightbitstosevenseg_2_led_pins_led0,       -- eightbitstosevenseg_2_led_pins.led0
			eightbitstosevenseg_2_led_pins_led1       => CONNECTED_TO_eightbitstosevenseg_2_led_pins_led1,       --                               .led1
			leds_external_connection_export           => CONNECTED_TO_leds_external_connection_export,           --       leds_external_connection.export
			pixelstream_0_conduit_end_0_lcd_red       => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_red,       --    pixelstream_0_conduit_end_0.lcd_red
			pixelstream_0_conduit_end_0_lcd_green     => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_green,     --                               .lcd_green
			pixelstream_0_conduit_end_0_lcd_blue      => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_blue,      --                               .lcd_blue
			pixelstream_0_conduit_end_0_lcd_hsync     => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_hsync,     --                               .lcd_hsync
			pixelstream_0_conduit_end_0_lcd_vsync     => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_vsync,     --                               .lcd_vsync
			pixelstream_0_conduit_end_0_lcd_de        => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_de,        --                               .lcd_de
			pixelstream_0_conduit_end_0_lcd_dclk      => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_dclk,      --                               .lcd_dclk
			pixelstream_0_conduit_end_0_lcd_dclk_en   => CONNECTED_TO_pixelstream_0_conduit_end_0_lcd_dclk_en,   --                               .lcd_dclk_en
			reset_reset_n                             => CONNECTED_TO_reset_reset_n,                             --                          reset.reset_n
			shiftregctl_0_shiftreg_ext_shiftreg_clk   => CONNECTED_TO_shiftregctl_0_shiftreg_ext_shiftreg_clk,   --     shiftregctl_0_shiftreg_ext.shiftreg_clk
			shiftregctl_0_shiftreg_ext_shiftreg_loadn => CONNECTED_TO_shiftregctl_0_shiftreg_ext_shiftreg_loadn, --                               .shiftreg_loadn
			shiftregctl_0_shiftreg_ext_shiftreg_out   => CONNECTED_TO_shiftregctl_0_shiftreg_ext_shiftreg_out,   --                               .shiftreg_out
			rotaryctl_right_rotary_event_rotary_cw    => CONNECTED_TO_rotaryctl_right_rotary_event_rotary_cw,    --   rotaryctl_right_rotary_event.rotary_cw
			rotaryctl_right_rotary_event_rotary_ccw   => CONNECTED_TO_rotaryctl_right_rotary_event_rotary_ccw,   --                               .rotary_ccw
			rotaryctl_right_rotary_in_rotary_in       => CONNECTED_TO_rotaryctl_right_rotary_in_rotary_in,       --      rotaryctl_right_rotary_in.rotary_in
			rotaryctl_left_rotary_event_rotary_cw     => CONNECTED_TO_rotaryctl_left_rotary_event_rotary_cw,     --    rotaryctl_left_rotary_event.rotary_cw
			rotaryctl_left_rotary_event_rotary_ccw    => CONNECTED_TO_rotaryctl_left_rotary_event_rotary_ccw,    --                               .rotary_ccw
			rotaryctl_left_rotary_in_rotary_in        => CONNECTED_TO_rotaryctl_left_rotary_in_rotary_in         --       rotaryctl_left_rotary_in.rotary_in
		);

