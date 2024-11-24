	module test_bench;
	parameter N _W = 16;
	reg [N_W-1:0] a, b; 
	wire [N_W:0] sum;
	reg [N_W:0] res;
	integer i;
	
	full_adder_Nb #(N_W) dut(.a(a), .b(b), .sum(sum[N_W-1:0]), .carry(sum[N_W]));
	
	initial begin
		for(i = 0; i < 1000; i=i+1) begin
			if(i == 999) begin
				a = {N_W{1'b1}};
				b = {N_W{1'b1}};
			end else begin
				a = $urandom_range(0, 2**N_W 1);
				b = $urandom_range(0, 2**N_W - 1);
			end
			#5;
			$display("========================================");
			$display("===== Case: %d a = %d, b = %d =====", i,a,b); 
			$display("========================================");

			res = a + b;
			$display("Exp: %d Actual: %d", res, sum);
			if (res === sum) begin
				$display(">>>>>>>>>>>>>>>  PASS   <<<<<<<<<<<<<<<\n");
			end else begin
				$display(">>>>>>>>>>>>>>>  FAIL   <<<<<<<<<<<<<<<\n");
				$finish;
			end
		end
		#100; $finish;
	end
endmodule
