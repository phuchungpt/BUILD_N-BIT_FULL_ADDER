module counter_control 
(
  // Communicate with timer_ip 
  input wire       clk     , 
  input wire       rst_n   , 
  input wire       dbg_mode, 
  
  // Communicate with register 
  input wire       timer_en, 
  input wire       div_en  , 
  input wire [3:0] div_val , 
  input wire       halt_req, 
  output reg       halt_ack, 
  
  // Communicate with counter 
  output reg       cnt_en  
); 

  reg [7:0] limit      ; 
  reg [7:0] cnt_tmp    ; 
  wire      paused     ; 
  wire      cnt_en_tmp1; 
  wire      cnt_en_tmp2; 
  wire      cnt_en_tmp3;
  wire      cnt_en_tmp ; 
  
  assign paused = dbg_mode & halt_req; 
  
// Limit value 
  always @(*) begin 
    case(div_val) 
	   4'b0000: limit = 8'd0  ; 
	   4'b0010: limit = 8'd3  ;
      4'b0011: limit = 8'd7  ;
		4'b0100: limit = 8'd15 ;
		4'b0101: limit = 8'd31 ;
		4'b0110: limit = 8'd63 ;
		4'b0111: limit = 8'd127;
		4'b1000: limit = 8'd255;
		default: limit = 8'd1  ; 
    endcase 
  end 

// Small counter 
  always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) 
	   cnt_tmp <= 8'h0; 
	 else if(paused)
	   cnt_tmp <= cnt_tmp;
	 else 
	   cnt_tmp <= (timer_en & div_en)? (cnt_tmp == limit)? 8'h0:cnt_tmp + 1'b1 : 8'h0; 
  end 

// Halt acknowledge
  always @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
	   halt_ack <= 1'b0; 
	 else 
	   halt_ack <= paused; 
  end 

// Cases counter enable temporary 
  assign cnt_en_tmp1 = ~div_en & timer_en; 
  assign cnt_en_tmp2 = (div_val == 4'b0) & div_en & timer_en; 
  assign cnt_en_tmp3 = (div_val != 4'b0) & timer_en & cnt_tmp == limit; 
  
  assign cnt_en_tmp  = cnt_en_tmp1 || cnt_en_tmp2 || cnt_en_tmp3; 
  
// Counter enable 
  assign cnt_en = cnt_en_tmp & !paused; 
  
endmodule