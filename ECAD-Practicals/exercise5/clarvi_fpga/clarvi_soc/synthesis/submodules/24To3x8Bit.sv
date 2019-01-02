module TwentyFourBitSplitter(
	input wire [23:0] in_1,
	output wire [7:0] out1,
	output wire [7:0] out2,
	output wire [7:0] out3);
	
	assign out1 = in_1[23:16];
	assign	out2 = in_1[15:8];
	assign out3 = in_1[7:0];

endmodule

