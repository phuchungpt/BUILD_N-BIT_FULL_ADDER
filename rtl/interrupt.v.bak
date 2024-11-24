module interrupt 
(
  // Comunicate with timer_ip 
  input wire clk               ,  
  input wire rst_n             , 
  input wire [3:0] pstrb       ,   
  input wire [31:0] wdata      , 
  output wire tim_int          , 
  
  // Comunicate with counter 
  input wire [63:0] cnt        , 
  
  // Comunicate with register 
  input wire [63:0] tcmp       , 
  input wire        int_en     , 
  input wire        tisr_wr_sel, 
  output reg        int_st
);

  wire int_set, int_clr; 
  
  assign int_set = (cnt = tcmp)? 1:0; 
  
  assign int_clr = tisr_wr_sel & (wdata[0] == 1'b1) & pstrb[0];
  
  always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin 
	   int_st <= 1'b0; 
	 end else if(int_clr)
	   int_st <= 1'b0; 
	 else 
	   int_st <= (int_set)? 1:int_st; 
  end 
  
  assign tim_int = (int_en && int_st)? 1:0; 

endmodule 
  