task run_test();
	begin
	test_bench.tim_pstrb = 4'b1111;
	#1;
	if(test_bench.int_en != 1'b0) begin
		$display("=====================================================");
		$display("t=%10d FAIL: int_en's value is not correct, expected = 1'b0, actual = 1'b%b", $stime, test_bench.int_en);
		$display("=====================================================\n");
		#100;
		$finish;
	end else begin
		$display("=====================================================");
		$display("t=%10d PASS: int_en's value is correct, expected =1'b0, actual = 1'b%b", $stime, test_bench.int_en); 
		$display("=====================================================\n");
	end
	if(test_bench.int_st != 1'b0) begin
		$display("=====================================================");
		$display("t=%10d FAIL: int_st's value is not correct, expected = 1'b0, actual = 1'b%b", $stime, test_bench.int_st);
		$display("=====================================================\n");
		#100;
		$finish;
	end else begin
		$display("====================================================="); 
		$display("t=%10d PASS: int_st's value is correct, expected = 1'b0, actual = 1'b%b", $stime, test_bench.int_st);
		$display("=====================================================\n");
	end
	#10;
	test_bench.sys_rst_n = 1;
	
	// Write cnt's value equal to tcmp (64'FFFFF_FFFF_FFFF_FFFF)
	test_bench.write_transfer_cnt (12'h04, 32'hFFFF_FFFF, 64'h0000_0000_FFFF_FFFF);
	test_bench.write_transfer_int_st(12'h08, 32'hFFFF_FFFF, 1'b1);
	
	// write cnt's value different from tcmp (64'hFFFF_FFFF_FFFF_FFFF) 
	test_bench.write_transfer_int_st(12'h04, 32'h1111_1111, 1'b1);
	
	test_bench.tim_pstrb = 4'b1110;
	test_bench.write_transfer_int_st(12'h18, 32'h0000_0001, 1'b1);
	
	test_bench.tim_pstrb = 4'b1111;
	test_bench.write_transfer_int_st(12'h18, 32'h0000_0001, 1'b0);
	
   //test_bench.write_tranfer_int_st(12'h04, 32'hFFFF_FFFF, 1'b0);
	test_bench.write_transfer_tim_int(12'h14, 32'hFFFF_FFF0, 1'b0);
	test_bench.write_transfer_tim_int(12'h14, 32'hFFFF_FFFF, 1'b0);
	test_bench.write_transfer_int_st(12'h18, 32'hFFFF_FFF0, 1'b0);
	test_bench.write_transfer_tim_int(12'h04, 32'hFFFF_FFFF, 1'b1);
	end
endtask