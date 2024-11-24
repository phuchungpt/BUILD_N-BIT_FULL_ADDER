task run_test(); 
	begin
		$display("============== REGISTER TCMPO ================");
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFFFF_FFFF);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'hoc, 12'hoc, 32'h0000_0000, 32'hFFFF_FF00);
		
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFFFF_FF00);
		 
		$display("============== write/read (pstrb[1] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0010;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFFFF_0000);
		
		$display("============== write/read (pstrb[2] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFFFF_0000);
		
		$display("============== write/read (pstrb[2] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0100;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFF00_0000);
		
		$display("============== write/read (pstrb[3] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'hFF00_0000);
		
		$display("============== write/read (pstrb[3] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b1000;
		test_bench.check_register(12'h0C, 12'h0C, 32'h0000_0000, 32'h000_0000);
		
		$display("============== toggle value (h -> 1) ================");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12'hoc, 12'h0c, 32'hffff_ffff, 32'hffff_ffff);
		
		$display("============== REGISTER_TCMP1 ================");
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_FFFF);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_FF00);

		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_FF00);
		
		$display("============== write/read (pstrb[1] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0010;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_0000);
		
		$display("============== write/read (pstrb[1] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_0000);
		
		$display("============== write/read (pstrb[2] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFFFF_0000);
		
		$display("============== write/read (pstrb[2] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0100;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFF00_0000);

		$display("============== write/read (pstrb[3] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'hFF00_0000);
		
		$display("============== write/read (pstrb[3] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b1000;
		test_bench.check_register(12'h10, 12'h10, 32'h0000_0000, 32'h0000_0000);
		
		$display("============== toggle value (H->L) ================");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12'h10, 12'h10, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
		
		$display("============== REGISTER_TIER  ================");
		$display("============== write/read (pstrb[0] = 1'b0)  ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h14, 12'h14, 32'hFFFF_FFFF, 32'h0000_0000);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h14, 12'h14, 32'hFFFF_FFFF, 32'h0000_0001);
		
		$display("============== write/read (pstrb[1] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h14, 12'h14, 32'h0000_0000, 32'h0000_0001);

		$display("============== write/read (pstrb[0] = 1'b1)) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h14, 12'h14, 32'h0000_0000, 32'h0000_0000);
		
		$display("============== toggle value (H->L) ================");
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12' hoc, 12'h0C, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
		
		$display("============== REGISTER_THCSR ================");
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h1C, 12'h1C, 32'hFFFF_FFFF, 32'h0000_0000);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h1C, 12'h1C, 32'hFFFF_FFFF, 32'h0000_0001);
		
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h1C, 12'h1C, 32'h0000_0000, 32'h0000_0001);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h1C, 12'h1C, 32'h0000_0000, 32'h0000_0000);
		
		$display("============== REGISTER_TDRO ================");
		$display("============== write/read (pstrb[0] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h0000_0000);
		
		$display("============== write/read (pstrb[0] 1'b1) ================");
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h0000_00FF);
		
		$display("============== write/read (pstrb[1] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h0000_00FF);
		
		$display("============== (pstrb[1] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0010;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h0000_FFFF);
		
		$display("============== write/read (pstrb[2] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h0000_FFFF);
		
		$display("============== write/read (pstrb[2] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b0100;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h00FF_FFFF);
		
		$display("============== write/read (pstrb[3] = 1'b0) ================");
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'h00FF_FFFF);
		
		$display("============== write/read (pstrb[3] = 1'b1) ================");
		test_bench.tim_pstrb = 4'b1000;
		test_bench.check_register(12'h04, 12'h04, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
		
		$display("============== REGISTER TDR1 ================");
		$display("============== write/read (pstrb[0] = 1'b0) ================");	
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h0000_0000);
		
		$display("============== write/read (pstrb[0] = 1'b1) ================");	
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h0000_00FF);
		
		$display("============== write/read (pstrb[1] = 1'b0) ================");	
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h0000_00FF);
		
		$display("============== write/read (pstrb[1] = 1'b1) ================");	
		test_bench.tim_pstrb = 4'b0010;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h0000_FFFF);
		
		$display("============== write/read (pstrb[2] = 1'b0) ================");	
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h0000_FFFF);
		
		$display("============== write/read (pstrb[2] = 1'b1) ================");	
		test_bench.tim_pstrb = 4'b0100;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h00FF_FFFF);
		
		$display("============== write/read (pstrb[3] = 1'b0) ================");	
		test_bench.tim_pstrb = 4'b0000;
		test_bench.check_register(12'h08, 12'h08, 32'hFFFF_FFFF, 32'h00FF_FFFF);
		
		$display("============== write/read (pstrb[3] 1'b1) ================");	
		test_bench.tim_pstrb = 4'b1000;
		test_bench.check_register(12'h08, 12'h08, 32'hffff_ffff, 32'hffff_ffff);
		
		$display("============== toggle divide value (L->H) ================");	
		test_bench.tim_pstrb = 4'b0001;
		test_bench.check_register(12'h00, 12'h00, 32'h0000_0002, 32'h0000_0102);
		
		$display("============== timer_enable  ================");	
		test_bench.tim_pstrb = 4'b1111;
		test_bench.check_register(12'h00, 12'h00, 32'h0000_0001, 32'h0000_0001);
		test_bench.read_transfer(12'h04, 32'h0000_0007);
	end
endtask
		