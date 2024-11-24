module apb_slave 
(
  // Communicate with timer_ip 
  input  wire clk       , 
  input  wire rst_n     , 
  input  wire psel      , 
  input  wire pwrite    , 
  input  wire penable   , 
  output wire tim_pready, 
  
  // Communicate with register 
  output wire wr_en     , 
  output wire rd_en     , 
); 
  
  reg wait_state; 
  
  assign wr_en = psel & penable & pwrite ; 
  assign rd_en = psel & pebable & !pwrite; 
  assign tim_pready = (psel && penable)? wait_state? 1'b1:1'b0 :1'b0;
  
  always @(posedge clk or negedge rst_n) begin 
   if(!rst_n)
	  wait_state <= 1'b0; 
	else 
	  wait_state <= (psel & penable);
	end 
  end 
endmodule 
