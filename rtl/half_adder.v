module half_adder (a_in, b_in, sum_out, carry_out);

  input a_in;
  input b_in;
  output sum_out;
  output carry_out;
  
  wire a_in, b_in, sum_out, carry_out;

  assign sum_out = a_in ^ b_in;
  assign carry out = a_in & b_in;
  
endmodule
