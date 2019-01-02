// rotary decoder template

module rotary
  (
	input  wire clk,
	input  wire rst,
	input  wire [1:0] rotary_in,
	output logic [7:0] rotary_pos,
        output logic rot_cw,
        output logic rot_ccw
   );	
	logic [1:0] clean_rot_in;
	debounce db0(clk, rst,rotary_in[0], clean_rot_in[0]);
	debounce db1(clk, rst, rotary_in[1], clean_rot_in[1]);
	logic [1:0] last_in;
	always_ff @(posedge clk or posedge rst) 
		if(rst)begin
				rot_cw <=0;
				rot_ccw<=0;
				last_in <= 2'b0;
				rotary_pos <= 0;
			end
		else begin 
			
			if(clean_rot_in== 2'b11 && last_in==2'b01) begin
				rot_cw <=1;
				rot_ccw <=0;
				rotary_pos <= rotary_pos+1;
			end
			else if(clean_rot_in== 2'b11 && last_in==2'b10) begin
				rot_cw <=0;
				rot_ccw <=1;
				rotary_pos <= rotary_pos-1;
			end
			else begin
				rot_cw <=0;
				rot_ccw <=0;
			end
			last_in<=clean_rot_in;
		
		end
		
endmodule // rotarydecoder
