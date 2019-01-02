
module clarvi_soc (
	clk_clk,
	eightbitstosevenseg_0_led_pins_led0,
	eightbitstosevenseg_0_led_pins_led1,
	eightbitstosevenseg_1_led_pins_led0,
	eightbitstosevenseg_1_led_pins_led1,
	eightbitstosevenseg_2_led_pins_led0,
	eightbitstosevenseg_2_led_pins_led1,
	leds_external_connection_export,
	pixelstream_0_conduit_end_0_lcd_red,
	pixelstream_0_conduit_end_0_lcd_green,
	pixelstream_0_conduit_end_0_lcd_blue,
	pixelstream_0_conduit_end_0_lcd_hsync,
	pixelstream_0_conduit_end_0_lcd_vsync,
	pixelstream_0_conduit_end_0_lcd_de,
	pixelstream_0_conduit_end_0_lcd_dclk,
	pixelstream_0_conduit_end_0_lcd_dclk_en,
	reset_reset_n,
	shiftregctl_0_shiftreg_ext_shiftreg_clk,
	shiftregctl_0_shiftreg_ext_shiftreg_loadn,
	shiftregctl_0_shiftreg_ext_shiftreg_out,
	rotaryctl_right_rotary_event_rotary_cw,
	rotaryctl_right_rotary_event_rotary_ccw,
	rotaryctl_right_rotary_in_rotary_in,
	rotaryctl_left_rotary_event_rotary_cw,
	rotaryctl_left_rotary_event_rotary_ccw,
	rotaryctl_left_rotary_in_rotary_in);	

	input		clk_clk;
	output	[6:0]	eightbitstosevenseg_0_led_pins_led0;
	output	[6:0]	eightbitstosevenseg_0_led_pins_led1;
	output	[6:0]	eightbitstosevenseg_1_led_pins_led0;
	output	[6:0]	eightbitstosevenseg_1_led_pins_led1;
	output	[6:0]	eightbitstosevenseg_2_led_pins_led0;
	output	[6:0]	eightbitstosevenseg_2_led_pins_led1;
	output	[9:0]	leds_external_connection_export;
	output	[7:0]	pixelstream_0_conduit_end_0_lcd_red;
	output	[7:0]	pixelstream_0_conduit_end_0_lcd_green;
	output	[7:0]	pixelstream_0_conduit_end_0_lcd_blue;
	output		pixelstream_0_conduit_end_0_lcd_hsync;
	output		pixelstream_0_conduit_end_0_lcd_vsync;
	output		pixelstream_0_conduit_end_0_lcd_de;
	output		pixelstream_0_conduit_end_0_lcd_dclk;
	output		pixelstream_0_conduit_end_0_lcd_dclk_en;
	input		reset_reset_n;
	output		shiftregctl_0_shiftreg_ext_shiftreg_clk;
	output		shiftregctl_0_shiftreg_ext_shiftreg_loadn;
	input		shiftregctl_0_shiftreg_ext_shiftreg_out;
	output		rotaryctl_right_rotary_event_rotary_cw;
	output		rotaryctl_right_rotary_event_rotary_ccw;
	input	[1:0]	rotaryctl_right_rotary_in_rotary_in;
	output		rotaryctl_left_rotary_event_rotary_cw;
	output		rotaryctl_left_rotary_event_rotary_ccw;
	input	[1:0]	rotaryctl_left_rotary_in_rotary_in;
endmodule
