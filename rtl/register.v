module register 
(
  // Communicate with timer top 
  input  wire        clk    ,  
  input  wire        rst_n  ,    
  input  wire [11:0] addr   , 
  input  wire [31:0] wdata  , 
  input  wire [3:0]  pstrb  , 
  output reg  [31:0] rdata  ,
 
  // Communicate with apb_slave 
  input  wire wr_en         ,
  input  wire rd_en         ,
  input  wire tim_pready    ,
  
  // Communicate with interrupt 
  input  wire int_st        , 
  output reg  int_en        ,
  output wire tisr_wr_sel   ,
  output reg  [63:0] tcmp   , 
  
  // Communicate with counter control 
  input  wire halt_ack      ,
  output reg  div_en        ,
  output reg  [3:0] div_val , 
  output reg  timer_en      ,
  output reg  halt_req      , 
  
  // Communicate with counter 
  input  wire [63:0] cnt    ,
  output wire tdr0_wr_sel   , 
  output wire tdr1_wr_sel   , 
  output wire cnt_clr  
); 

  reg  error           ; 
  reg  timer_en_delayed; 
  wire error1, error2  ;
  wire tcr_wr_sel      ; 
 
  // Register 
  parameter ADDR_TCR   = 12'h00; 
  parameter ADDR_TDR0  = 12'h04; 
  parameter ADDR_TDR1  = 12'h08; 
  parameter ADDR_TCMP0 = 12'h0C; 
  parameter ADDR_TCMP1 = 12'h10; 
  parameter ADDR_TIER  = 12'h14; 
  parameter ADDR_TISR  = 12'h18; 
  parameter ADDR_THCSR = 12'h1C; 
  
  // Write transfer 
  always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin 
	 // reg_tcr 
	   div_val  <= 4'b0001; 
		div_en   <= 1'b0   ; 
		timer_en <= 1'b0   ;
	 // reg_tcmp0/1
	   tcmp     <= 64'hFFFF_FFFF_FFFF_FFFF; 
	 // reg_tier 
	   int_en   <= 1'b0   ; 
	 // reg_thcsr
	   halt_req <= 1'b0   ; 
	 end else if(wr_en) begin 
	   case(addr) 
		  ADDR_TCR: begin 
		    if(!error) begin 
			   div_val            <= (pstrb[1])? wdata[11:8]: div_val           ;
				{div_en, timer_en} <= (pstrb[0])? wdata[1:0] : {div_en, timer_en};
			 end 
		  end 
		  ADDR_TCMP0: begin 
		    tcmp[31:24] <= (pstrb[3])? wdata[31:24]: tcmp[31:24];
			 tcmp[23:16] <= (pstrb[2])? wdata[23:16]: tcmp[23:16];
			 tcmp[15:8]  <= (pstrb[1])? wdata[15:8] : tcmp[15:8] ;
			 tcmp[7:0]   <= (pstrb[0])? wdata[7:0]  : tcmp[7:0]  ;
		  end  
		  ADDR_TCMP1: begin 
		    tcmp[63:56] <= (pstrb[3])? wdata[31:24]: tcmp[63:56];
			 tcmp[55:48] <= (pstrb[2])? wdata[23:16]: tcmp[55:48];
			 tcmp[47:40] <= (pstrb[1])? wdata[15:8] : tcmp[47:40];
			 tcmp[39:32] <= (pstrb[0])? wdata[7:0]  : tcmp[39:32];
		  end 
		  ADDR_TIER : int_en   <= (pstrb[0])? wdata[0]: int_en  ; 
		  ADDR_THCSR: halt_req <= (pstrb[0])? wdata[0]: halt_req;
		  default   : begin 
		    div_val  <= div_val ; 
			 div_en   <= div_en  ; 
			 timer_en <= timer_en; 
			 tcmp     <= tcmp    ; 
			 int_en   <= int_en  ; 
			 halt_req <= halt_req; 
		  end  
		endcase 
	 end 
  end 
  
  // Read transfer 
  always @(*) begin 
   if(rd_en) begin 
	  if(tim_pready) begin 
	    case(addr)
		   ADDR_TCR  : rdata <= {20'h0, div_val, 6'h0, div_en, timer_en};  
			ADDR_TDR0 : rdata <= cnt[31:0] 										 ; 
			ADDR_TDR1 : rdata <= cnt[63:32]								 		 ;
			ADDR_TCMP0: rdata <= tcmp[31:0]										 ;
			ADDR_TCMP1: rdata <= tcmp[63:32]										 ;
			ADDR_TIER : rdata <= {31'h0, int_en}								 ;
			ADDR_TISR : rdata <= {31'h0, int_st}								 ;
			ADDR_THCSR: rdata <= {30'h0, halt_ack, halt_req}				 ;
			default   : rdata <= 32'h0												 ;
		 endcase 
	  end 
	end else begin 
	      rdata <= 32'h0; 
	end 
  end 
  
  // reg_tdr0/1 write select 
  assign tdr0_wr_sel = wr_en & (addr == ADDR_TDR0); 
  assign tdr1_wr_sel = wr_en & (addr == ADDR_TDR1);
  
  // reg_tisr write select 
  assign tisr_wr_sel = wr_en & (addr == ADDR_TISR);
  
  // error handling 
  assign tim_pslverr = tim_pready & error        ; 
  assign tcr_wr_sel  = wr_en & (addr == ADDR_TCR); 
  
  assign error1 = (pstrb[0])? wdata[1]    ^ div_en  : 1'b0; 
  assign error2 = (pstrb[1])? wdata[11:8] ^ div_val : 1'b0;
  
  always @(*) begin 
    if(tdr_wr_sel) begin 
	   if(wdata[11:8] > 4'b1000)
		  error <= (pstrb[1])? 1'b1: 1'b0; 
		else if(timer_en)
		  error = error1 | error2;
		else 
		  error = 1'b0; 
	 end else 
      error <= 1'b0; 
  end 
  
  // Counter clear 
  always @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
	   timer_en_delayed <= 1'b0; 
	 else 
	   timer_en_delayed <= timer_en; 
  end 
  
  assign cnt_clr = timer_en_delayed & ~timer_en; 
 
endmodule
  
  
  
  
  
  
  
  
  
  
  
  
  