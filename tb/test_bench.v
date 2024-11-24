module test_bench;
//varaible declare 
reg sys_clk;
reg sys_rst_n ;
reg tim_psel;
reg tim_pwrite;
reg tim_penable;
reg [11:0] tim_paddr;
reg [31:0] tim_pwdata; 
reg dbg_mode;
reg [3:0] tim_pstrb;
wire tim_pready;
wire tim_pslverr;
wire tim_int;
wire [31:0] tim_prdata ;

wire wr_en, rd_en, int_en, int_st; 
wire tisr_wr_sel;

wire [63:0] cnt;

//clock create
initial begin
	sys_clk = 1'b0;
	forever #5 sys_clk = ~sys_clk;
end

//instance timer_ip 
timer_top u_dut(.*);

assign wr_en  = u_dut.wr_en_tmp ;
assign rd_en  = u_dut.rd_en_tmp ;
assign int_en = u_dut.int_en_tmp;
assign int_st = u_dut.int_st_tmp;
assign cnt    = u_dut.cnt_tmp   ;
assign tisr_wr_sel = u_dut.tisr_wr_sel_tmp;


task apb_slave(input write);
	integer i;
	begin
		case(write)
			1'b1: begin
				for(i = 0; i <= 3; i = i+1) begin
					{tim_psel, tim_penable} = i;
					#1;
					$display("tim_pwrite = %b, tim_psel = %b, tim_penable = %b", tim_pwrite, tim_psel, tim_penable);
						if({tim_psel, tim_penable} != 2'b11) begin 
							if(wr_en != 1'b0) begin
								$display("===========================================================================");
								$display("t=%10d FAIL: wr_en's value is not correct, expected = 1'b0, actual = 1'b%b", $stime, wr_en); 
								$display("==========================================================================\n");
								#100;
								$finish;
							end else begin
								$display("===========================================================================");
								$display("t=%10d PASS: wr_en's value is correct, expected = 1'b0, actual = 1'b%b", $stime, wr_en);
								$display("===========================================================================\n");
							end
						end else begin
							if(wr_en != 1'b1) begin
								$display("===========================================================================");
								$display("t=%10d FAIL: wr_en is not asserted, expected = 1'b1, actual =1'b%b", $stime, wr_en);
								$display("===========================================================================/n");
								#100;
								$finish;
							end else begin
								$display("===================================================================");
								$display("t=%10d PASS: wr_en is asserted, expected = 1'b1, actual = 1'b%b", $stime, wr_en);
								$display("==================================================================\n");
							end
							@(posedge sys_clk);
							#1;
							if(tim_pready != 1'b1) begin
								$display("==================================================================");
								$display("t=%10d FAIL: tim_pready is not asserted, expected = 1'b1, actual = 1'b%b", $stime, tim_pready);
								$display("==================================================================\n");
								#100;
								$finish;
							end else begin
								$display("==================================================================");
								$display("t=%10d PASS: tim_pready is asserted, expected = 1'b1, actual = 1'b%b", $stime, tim_pready);
								$display("==================================================================\n");
							end 
						end 
						@(posedge sys_clk);
					end
				end		
				1'b0: begin
				for(i = 0; i <= 3; i = i+1) begin
					{tim_psel, tim_penable} = i;
					#1;
					$display("tim_pwrite = %b, tim_psel = %b, tim_penable = %b", tim_pwrite, tim_psel, tim_penable);
					if({tim_psel, tim_penable} != 2'b11) begin
						if(rd_en != 1'b0) begin=
							$display("===========================================================");
							$display("t=%d FAIL: rd_en's value is not correct, expected = 1'b0, actual = 1'b%b", $stime, rd_en);
							$display("===========================================================\n");
							#100;
							$finish;
						end else begin	
							$display("===========================================================");
							$display("t=%10d PASS: rd_en's value is correct, expected = 1'b0, actual = 1'b%b", $stime, rd_en);
						   $display("===========================================================\n");
						end
					end else begin
						if(rd_en != 1'b1) begin
							$display("============================================================");
							$display("t=%10d FAIL: rd_en is not asserted, expected = 1'b1, actual = 1'b%b", $stime, rd_en);
							$display("============================================================\n");
						#100;
						$finish;
						end else begin
							$display("=============================================================");
							$display("t=%10d PASS: rd_en is asserted, expected 1'b1, actual = 1'b%b", $stime, rd_en); 
							$display("=============================================================\n");
						end
						@(posedge sys_clk);
						#1;
						if(tim_pready != 1'b1) begin
							$display("==============================================================");
							$display("t=%10d FAIL: tim_pready is not asserted, expected = 1'b1, actual = 1'b%b", $stime, tim_pready);
							$display("==============================================================\n");
							#100;
							$finish;
						end else begin
							$display("==============================================================");
							$display("t=%10d PASS: tim_pready is asserted, expected = 1'b1, actual = 1'b%b", $stime, tim_pready);
							$display("==============================================================\n");
				      end 
					end 
					@(posedge sys_clk);
				end
			end 	
		endcase 
	end 
endtask


task write_transfer(input [11:0] addr, input [31:0] pwdata); 
	begin
		tim_pwrite  = 1'b1;
		tim_paddr   = addr;
		tim_pwdata  = pwdata;
		tim_psel    = 1'b0;
		tim_penable = 1'b0;
		@(posedge sys_clk);
		tim_psel = 1'b1; 
		@(posedge sys_clk);
		tim_penable = 1'b1;
		@(posedge sys_clk); 
	   #1;
		if(cnt != written_data) begin
			$display("=============================================================");
			$display("t=%10d FAIL: cnt's value is not correct, expected = %h, actual = %h", $stime, written_data, cnt); =\n");
			$display("=============================================================\n");			
			#100;
			$finish;
		end else begin
			$display("==============================================================");
			$display("t=%10d PASS: cnt's value is correct, expected = h, actual = %h", $stime, written_data, cnt);
			$display("=-------------------------------------------------------------\n");
		end
		@(posedge sys_clk);
	end
endtask

task write_transfer_cnt(input [11:0] addr, input [31:0] pwdata, input [63:0] written_data); 
	begin
		tim_pwrite = 1'b1;
		tim_paddr = addr; 
		tim_pwdata = pwdata; 
		tim_psel = 1'b0; 
		tim_penable = 1'b0;
		@(posedge sys_clk);
		tim_psel = 1'b1;
		@(posedge sys_clk);
		tim_penable = 1'b1;
		repeat(2) begin 
			@(posedge sys_clk);
		end 
		#1;
		if(cnt != written_data) begin
			$display("===============================================================");
			$display("t=%10d FAIL: cnt's value is not correct, expected = %h, actual = %h", $stime, written_data, cnt);
			$display("==============================================================\n");
			#100;
			$finish;
		end else begin
			$display ("============================================================"):
			$display("t=%10d PASS: int_st's value is correct, expected = %h, actual = %h", $stime, written_data, int_st);
			$display ("============================================================\n");
		end
		@(posedge sys_clk);
	end
endtask

task write_transfer tim int (input [11:0] addr, input [31:0] pwdata, input written data) :
	begin
		tim pwrite = l'b1;
		tim paddr  = addr;
		tim pwdata = pwdata;
		tim_psel   = 1'b0;
		tim penable = 1'b0;
		@(posedge sys_clk);
		tim_pset = 1'b1;
		@(posedge sys_clk] ;
		tim penable = 1'b1;
		repeat (2) begin
			@(posedge sys_clk;
		end
		#1:
		if(tim_int != written_data) begin
			$display("========================================================================");
			$display("t=%10d FAIL: tim int's value is not correct, expected = %h, actual = %h", $stime, written data, tim int);
			$display("========================================================================\n");
			#10:
			$finish;
		end else begin
			$display("========================================================================");
			$display("t=%10d PASS: tim int's value is correct, expected = %h, actual = %h", Sstime, written_data, tim_int);
			$display("========================================================================\n");
		end
		@(posedge sys clk);
	end
endtask

task read_transfer(input [11:0] addr, input [31:0] check value);
	begin
		tim paddr  = addr;
		tim pwrite = 1'b0;
		tim psel   = 1'b0;
		tim penable = 1'b0;
		@(pasedge sys_clk) ;
		tim psel = 1'b1;
		@[posedge sys_clk) ;
		tim_penable = 1'b1;
		@[posedge sys_clk);
		if(tim prdata !- check_value) begin
			$display("========================================================");
			$display("t=%10d FAIL: Prdata value is not correct, expected = 32'h%h, actual = 32'h%h", $stime, check value, tim_prdata):
			$display("======================================================\n");
			#10;
			$finish;
		end else begin
			$display("========================================================"):
			$display("t-%10d PASS: Prdata value is correct, expected = 32'h%h, actual = 32'h%h", $stime, check_value, tim_prdata);
			$display("========================================================");
		end
		@[posedge sys_clk);
	end
endtask


task check_div_val(input [31:0] pwdata, input [31:0] written_data, input [32:0] pwdata_clr); 
	integer i;
	begin
		tim_pwrite  = 1'b1;
		tim_paddr   = 12'h00;
		tim_pwdata  = pwdata;
		tim_psel    = 1'b0;
		tim_penable = 1'b0;
		@(posedge sys_clk); 
		tim_psel = 1'b1; 
		@(posedge sys_clk); 
		tim_penable = 1'b1;
		repeat (2) begin
			@(posedge sys_clk);
		end
		tim_pwrite  = 1'b0;
		tim_paddr   = 12'h04;
		tim_psel    = 1'b0; 
		tim_penable = 1'b0; 
		case (pwdata[11:8]) 
			4'b0000: i = 0;
			4'b0001: i = 0;
			4'b0010: i = 1;
			4'b0011: i = 4;
			4'b0100: i = 12;
			4'b0101: i = 28; 
			4'b0110: i = 60;
			4'b0111: i = 124; 
			4'b1000: i = 252;
		endcase
		repeat (1 + i) begin
			@(posedge sys_clk);
		end
		@(posedge sys_clk);
		tim_psel = 1'b1;
		@(posedge sys_clk);
		tim_penable = 1'b1;
		@(posedge sys_clk);
		#1;
		if(tim_prdata != written_data) begin
			$display("=============================================");
			$display("t=%10d FAIL: prdata value is not correct, expected = 32'h%h, actual = 32'h%h", $time, written_data, tim_prdata);
			$display("=============================================\n");
			#100;
			$finish;
		end else begin
			$display("================================================");
			$display("t=%10d PASS: prdata value is correct, expected = 32'h%h, actual = 32'h%h", $time, written_data, tim_prdata);
			$display("=============================================\n");
		end 
		@(posedge sys_clk);
		tim_pwrite  = 1'b1;
		tim_paddr   = 12'h00;
		tim_pwdata  = pwdata;
		tim_psel    = 1'b0;
		tim_penable = 1'b0;
		@(posedge sys_clk);
		tim_psel = 1'b1;
		@(posedge sys_clk); 
		tim_penable = 1'b1; 
		repeat (2) begin
			@(posedge sys_clk);
		end
	end
endtask

task write_transfer_tim_pslverr(input [11:0] addr, input [31:0] pwdata, input written_data);
	begin
		tim_pwrite  = 1'b1;
		tim_paddr  	= addr;
		tim_pwdata  = pwdata; 
		tim_psel 	= 1'b0;
		tim_penable = 1'b0; 
		@(posedge sys_clk); 
		tim_psel = 1'b1; 
		@(posedge sys_clk); 
		tim_penable = 1'b1; 
		@(posedge sys_clk);	
		#1;
		if(tim_pslverr != written_data) begin
			$display("================================================");
			$display("t=%10d FAIL: tim_pslverr value is correct, expected = %b, actual = %b", $stime, written_data, tim_pslverr);
			$display("================================================\n");
			#100;
			$finish;
		end else begin
			$display("================================================");
			$display("t=%10d PASS: tim_pslverr value is not correct, expected = %b, actual = %b", $stime, written_data, tim_pslverr);
			$display("================================================\n");
		end
		@(posedge sys_clk);
	end
endtask


task check_register(input [11:0] addr1, input [11:0] addr2, input [31:0] pwdata, input [31:0] written_data); 
	begin
		tim_pwrite  = 1'b1;
		tim_paddr   = addr1;
		tim_pwdata  = pwdata;
		tim_psel    = 1'b0;
		tim penable = 1'b0;
		@(posedge sys_clk); 
		tim_psel = 1'b1; 
		@(posedge sys_clk); 
		tim_penable = 1'b1; 
		repeat (2) begin
			@(posedge sys_clk);
		end
		tim_pwrite = 1'b0;
		tim_paddr  = addr2;
		tim_psel   = 1'b0;
		tim_penable = 1'b0;
		@(posedge sys_clk);
		tim_psel = 1'b1; 
		@(posedge sys_clk);
		tim_penable = 1'b1;
		@(posedge sys_clk);
		#1;
		if(tim_prdata != written_data) begin
			$display("============================================");
			$display("t=%10d FAIL: prdata value is not correct, expected = 32'h%h, actual = 32'h%h", $time, written_data, tim_prdata);
			$display("============================================\n");
			#100;
			$finish;
		end else begin
			$display("============================================");
			$display("t=10d PASS: prdata value is correct, expected = 32'h %h, actual 32'h%h", $time, written_data, tim_prdata);
			$display("============================================\n");
		end
		@(posedge sys_clk);
	end
endtask


//include run_test which is testcase name renamed by script
	`include "run_test.v"
	
//Testcase call
initial begin
	sys_rst_n = 1'b0;
	dbg_mode = 1'b0;
	#100;
	sys_rst_n = 1'b1;
	
//Call run_test
	run_test();
	#100;
	$finish;
end
endmodule

	
	