module tlight(input logic clk,
              output logic r,
              output logic a,
              output logic g);

logic [2:0] state = 0;
// enter code here
always_ff @(posedge clk)
  if(state==0 || state==5 || state==7 || state==3)
    state<=4;
  else begin
     state[1] <= ! state[1];
     state [2] <= (state==2 || state==4);
     state[0] <=( state[2] && state[1]);
  end
        

assign g = state[0];  
assign a = state[1];  
assign r = state[2]; 
endmodule // tlights
