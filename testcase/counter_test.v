task run_test(); 
	begin 
		$display("====================== Initial Value ====================\n");
		
		$display("===== Register: TCR ======");
		test_bench.read_transfer (12'h00, 32'h0000_0100);
		
		$display("==== Register: TDRO ==== ");
		test_bench.read_transfer(12'h04, 32'h0000_0000);
		
		$display("==== Register: TDR1 ==== ");
		test_bench.read_transfer(12'h08, 32'h0000_0000);
		
		$display("==== Register: TCMP0 ====");
		test_bench.read_transfer (12'h0C, 32'hFFFF_FFFF);
		
		$display("==== Register: TCMP1 ======");
		test_bench.read_transfer(12'h10, 32'hFFFF_FFFF);
		
		$display("==== Register: TIER ======");
		test_bench.read_transfer(12'h14, 32'h0000_0000);

		$display("==== Register: TISR ======");
		test_bench.read_transfer(12'h18, 32'h0000_0000);
		
		$display("==== Register: THCSR ======");
		test_bench.read_transfer (12'h1C, 32'h0000_0000);
		
		
		$display("==================== Counter in default mode =========================\n");
		$display("==================== Timer enable (pstrb[0] = 1'b0) ======================);

		test_bench.tim_pstrb = 4'b1100;
		test_bench.check_register(12'h00, 12'h00, 32'h0000_0001, 32'h0000_0100); 
		test_bench.read_transfer(12'h04, 32'h0000_0000);
		
		$display("==================  Timer enable (pstrb[0] = 1'b1) ====================\n");
		test_bench.tim_pstrb = 4'b1101;
		test_bench.check_register(12'h00, 12'h00, 32'h0000_0001, 32'h0000_0101);
		test_bench.read_transfer (12'h04, 32'h0000_0008);
		
		$display("==============  Write value (Max value 32bit) ================ \n");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFF6, 32'hFFFF_FFF9); 
		repeat (3) begin
			@(posedge test_bench.sys_clk);
		end
		test_bench.read_transfer(12'h04, 32'h0000_0000);
		test_bench.read_transfer(12'h08, 32'h0000_0001);
		
		$display("=================== Counter clear ================ \n");
		test_bench.check_register(12'h00, 12'h04, 32'h0000_0100, 32'h0000_0000); 
		test_bench.read_transfer (12'h08, 32'h0000_0000); 
		test_bench.read_transfer(12'h04, 32'h0000_0000);
		
		$display("================== Write value (Max value 64bit) ================ \n");
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'hFFFF_FFFF); 
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFD, 32'hFFFF_FFFD); 
		test_bench.check_register(12'h00, 12'h04, 32'h0000_0101, 32'h0000_0001); 
		test_bench.read_transfer(12'h08, 32'h0000_0000);
		
		$display("================== Halt_mode (test_bench.dbg_mode and halt_req) (pstrb[0] = 1'b0) ================ \n");
		test_bench.tim_pstrb = 4'b1110; 
		test_bench.dbg_mode = 1'b1;
		test_bench.check_register(12'h1C, 12'h1C, 32'hFFFF_FFFF, 32'h0000_0000);
		

		$display("================== Halt_mode (test_bench.dbg_mode and halt_req) (pstrb[0] = 1'b1) ================ \n");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12'h1C, 12'h1C, 32'hFFFF_FFFF, 32'h0000_0003);
		
		$display("==============    Halt_mode (stop_value)   ================ \n");
		test_bench.read_transfer (12'h04, 32'h0000_0011);
		
		$display("==============    Halt_mode (test_bench.dbg_mode= 0 and halt_req) ===============");
		test_bench.dbg_mode = 0;
		test_bench.read_transfer (12'h1C, 32'h0000_0001);
		
		$display("==============    Halt_mode (release counter) ===============");
		test_bench.read_transfer (12'h04, 32'h0000_0018);
		
		$display("==============    Error handling ===============");
		$display("==============    Change value of div_en (pstrb[0] 1'b0) ===============");
		test_bench.tim_pstrb = 4'b1110; 
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0103, 1'b0);
		test_bench.read_transfer (12'h00, 32'h0000_0101);
		
		$display("============= Change value of div_en (pstrb[0] = 1'b1) ==========="); 
		test_bench.tim_pstrb = 4'b1111;
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0103, 1'b1);
		test_bench.read_transfer(12'h00, 32'h0000_0101);

		$display("============= Change value of div_val (pstrb[1] = 1'b0 ===========");
		test_bench.tim_pstrb = 4'b1101;
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0401, 1'b0);
		test_bench.read_transfer(12'h00, 32'h0000_0101);
		
		$display("============= Change value of div_val (pstrb[1] = 1'b1) ===========");
		test_bench.tim_pstrb = 4'b1111; 
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0401, 1'b1);
		test_bench.read_transfer (12'h00, 32'h0000_0101);
		
		$display("============= Prohibit value of div_val (pstrb[1] = 1'b0) ===========");
		test_bench.tim_pstrb = 4'b1101;
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0F01, 1'b0);
		test_bench.read_transfer(12'h00, 32'h0000_0101);
		
		$display("============= Prohibit value of div_val (pstrb[0] = 1'b1) ===========");
		test_bench.tim_pstrb = 4'b1111;
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0901, 1'b1);
		test_bench.read_transfer (12'h00, 32'h0000_0101);
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0A01, 1'b1);
		test_bench.read_transfer (12'h00, 32'h0000_0101);
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0B01, 1'b1);
		test_bench.read_transfer(12'h00, 32'h0000_0101);
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0C01, 1'b1);
		test_bench.read_transfer(12'h00, 32'h0000_0101);
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0E01, 1'b1);
		test_bench.read_transfer (12'h00, 32'h0000_0101);
		
		test_bench.write_transfer_tim_pslverr(12'h00, 32'h0000_0F01, 1'b1);
		test_bench.read_transfer(12'h00, 32'h0000_0101);
			
		$display("====================== Counter in control mode ==================");
		$display("====================== Counter divide ==================");
		test_bench.check_register(12'h00, 12'h00, 32'h0000_0100, 32'h0000_0100);
		
		$display ("Test case 1: div_val = 4'b0000");
		test_bench.check_div_val (32'h0000_0003, 32'h0000_0004, 32'h0000_0002);
		
		$display("Test case 2: div_val = 4'b0001");
		test_bench.check_div_val(32'h0000_0103, 32'h0000_0002, 32'h0000_0102);
			
		$display("Test case 3: div_val = 4'b0010");
		test_bench.check_div_val(32'h0000_0203, 32'h0000_0001, 32'h0000_0202);
		
		$display ("Test case 4: div_val = 4'b0011");
		test_bench.check_div_val(32'h0000_0303, 32'h0000_0001, 32'h0000_0302);
		
		$display ("Test case 5: div_val = 4'b0100");
		test_bench.check_div_val (32'h0000_0403, 32'h0000_0001, 32'h0000_0402);
		
		$display ("Test case 6: div_val = 4'b0101");
		test_bench.check_div_val(32'h0000_0503, 32'h0000_0001, 32'h0000_0502);
		
		$display("Test case 7: div_val = 4'b0110");
		test_bench.check_div_val(32'h0000_0603, 32'h0000_0001, 32'h0000_0602);
		
		$display("Test case 8: div_val = 4'b0111");
		test_bench.check_div_val (32'h0000_0703, 32'h0000_0001, 32'h0000_0702);
		
		$display ("Test case 9: div_val = 4'b1000");
		test_bench.check_div_val (32'h0000_0803, 32'h0000_0001, 32'h0000_0802);
		
		$display("====================== Counter control mode (when cnttmp matching limit ==================");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.write_transfer(12'h00, 32'h0000_0802); 
		test_bench.write_transfer (12'h00, 32'h0000_0303);
		repeat (5) begin
			@(posedge test_bench.sys_clk);
		end
		
		test_bench.dbg_mode = 1'b1;
		test_bench.write_transfer (12'h1C, 32'h0000_0001); 
		test_bench.write_transfer (12'h00, 32'h0000_0302); 
		
		test_bench.dbg_mode = 1'b0;
		test_bench.read_transfer (12'h04, 32'h0000_0000);

		$display("====================== Write data (max value 32bit) ==================");
		test_bench.check_register(12'h00, 12'h00, 32'hFFFF_F1F3, 32'h0000_0103);
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFF3, 32'hFFFF_FFF5);
		
		repeat (18) begin
			@(posedge test_bench.sys_clk);
		end
		test_bench.read_transfer(12'h04, 32'h0000_0000); 
		test_bench.read_transfer(12'h08, 32'h0000_0001);

		$display("====================== Counter clear ==================");
		test_bench.check_register(12'h00, 12'h04, 32'h0000_0102, 32'h0000_0000); 
		test_bench.read_transfer(12'h08, 32'h0000_0000);
		
		$display("====================== Write data (max value 64bit) ==================");
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'hFFFF_FFFF); 
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFD, 32'hFFFF_FFFD); 
		test_bench.check_register(12'h00, 12'h04, 32'h0000_0103, 32'hFFFF_FFFF); 
		repeat (2) begin
			@(posedge test_bench.sys_clk);
		end
			#1;
		if(test_bench.tim_prdata != 32'h0000_0000) begin
			$display("=========================================================");
			$display("t=%10d FAIL: prdata value is not correct, counter doesn't reset after max value, expected = 32'h0000_0000, actual = 32'h%h", $stime, test_bench.tim_prdata);
			$display("=========================================================\n");
			#100;
			$finish;
		end else begin
			$display("=========================================================");
			$display("t=%10d PASS: prdata value is correct, counter is reset after max value, expected = 32'h00000_0000, actual = 32'h %h", $stime, test_bench.tim_prdata);
			$display("==========================================================\n");
		end
		test_bench.read_transfer(12'h08, 32'h0000_0000);
	
		$display("====================== halt_mode(stop cnt's value) ==================");
		test_bench.dbg_mode = 1'b1;
		test_bench.read_transfer (12'h04, 32'h0000_0002);
		
		$display("====================== halt_mode (halt_req and halt_ack) ==================");
		test_bench.check_register(12'h1C, 12'h1C, 32'hFFFF_FFF0, 32'h0000_0000);
		
		$display("====================== halt_mode (halt_req and halt_ack) ==================");
		test_bench.read_transfer (12'h04, 32'h0000_0006);

	end
endtask

		
		
		
		
		