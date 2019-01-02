// debounce template

module debounce
  (
	input wire       clk,       // 50MHz clock input
	input wire       rst,       // reset input (positive)
	input wire       bouncy_in, // bouncy asynchronous input
	output reg 		 clean_out  // clean debounced output
   );
reg prev_syncbouncy = 0;
reg [13:0] counter;
wire counterAtMax = &counter; // true for max val of counter
logic  syncbouncy;
logic metastable;

always_ff@(posedge clk or posedge rst)
	if(rst) begin
		counter<=0;
		prev_syncbouncy <=0;
		clean_out <=0;
	end else begin 
		metastable<=bouncy_in;
		syncbouncy <=metastable;
		prev_syncbouncy <= syncbouncy;
         	if(syncbouncy != prev_syncbouncy) 
			counter<=0;				
		else if(!counterAtMax)
			counter<=counter+1;
		else 
			clean_out<=syncbouncy;
	end
endmodule // debounce
