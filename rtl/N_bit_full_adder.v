module N_bit_full_adder.v #(parameter N_W = 2) (
  input wire [N_W-1:0] a,
  input wire [N_W-1:0] b,
  output wire [N_W-1:0] sum,
  output wire carry
  wire [N_W:0] carry_chain;
  
  assign carry_chain[0] = 1'b0;
  genvar i;
  generate
  for (i = 0; i < N_W; i = i + 1) begin: full_adder_chain 
    full_adder u_full_adder (
      .a(a[i]),
      .b(b[i]),
      .c(carry_chain[i]),
      .sum(sum[i]),
      .carry (carry_chain [i+1])
    );
  end
  endgenerate
  assign carry = carry_chain[N_W];
  endmodule
