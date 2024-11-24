task run_test();
	begin
		test_bench.tim_pwrite = 1;
		#10;
		test_bench.sys_rst_n  = 1;
		test_bench.apb_slave (test_bench.tim_pwrite);
		test_bench.tim_pwrite = 0;
		test_bench.apb_slave(test_bench.tim_pwrite);
	end
endtask