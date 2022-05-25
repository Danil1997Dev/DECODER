module IIR
(
  input clk,reset_l, start,
  input [31:0] i_signal, 
  output logic [31:0] o_signal = 0 
);

  logic en = 1;
  
  logic [3:0] cnt;
  logic sampl; 
  
  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin 
		    cnt <= 0;
			 sampl <= 0;
		  end
		else
		  begin if (start) begin
		    if (cnt == 10)
			   begin
		        cnt <= 0;
			     sampl <= 1;
				end
		    else
			   begin
		        cnt <= cnt + 1;
			     sampl <= 0;
				end 
		  end end
	 end
  
  
  const logic [31:0] S = {1'b0,8'b1100111,23'b00000000000000000000000}; 
  const logic [31:0] A2 = {1'b1,8'b1111111,23'b11111111110111110011101}; 
  const logic [31:0] A3 = {1'b0,8'b1111110,23'b11111111101111100111010}; 
  const logic [31:0] B2 = {1'b1,8'b10000000,23'b00000000000000000000000}; 
  const logic [31:0] B3 = {1'b0,8'b1111111,23'b00000000000000000000000}; 
  
  const logic [31:0] S1 = {1'b0,8'b1111001,23'b11101011100001010000000}; 
  const logic [31:0] A12 = {1'b1,8'b1111111,23'b01111010111000010100011}; 
  const logic [31:0] A13 = {1'b0,8'b1111110,23'b11010111000010100011110}; 
  const logic [31:0] B12 = {1'b1,8'b1111011,23'b01110000101000111100000}; 
  const logic [31:0] B13 = {1'b0,8'b1111011,23'b01110000101000111100000};
 
  bit [31:0] mlt_s = 0;
  bit [31:0] summ_a2 = 0;
  bit [31:0] summ_a3 = 0;
  bit [31:0] sh_1 = 0; 
  bit [31:0] sh_2 = 0;
  bit [31:0] summ_b2 = 0;
  bit [31:0] summ_b3 = 0;
  bit [31:0] mlt_a3 = 0;
  bit [31:0] mlt_a2 = 0;
  bit [31:0] mlt_b2 = 0;
  bit [31:0] mlt_b3 = 0;
  
  FP_MULT  mult_s (.clk(clk),.areset(~reset_l),.en(en),.a(i_signal),.b(S1),.q(mlt_s));
  
  FP_SUB sub_a2 (.clk(clk),.areset(~reset_l),.en(en),.a(mlt_s),.b(mlt_a2),.q(summ_a2));
  
  FP_SUB sub_a3 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_a2),.b(mlt_a3),.q(summ_a3)); 
  
  FP_MULT  mult_a2 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_1),.b(A12),.q(mlt_a2));
  
  FP_MULT  mult_b2 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_1),.b(B12),.q(mlt_b2)); 
  
  FP_MULT  mult_b3 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_2),.b(B13),.q(mlt_b3)); 
  
  FP_MULT  mult_a3 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_2),.b(A13),.q(mlt_a3));
  
  FP_ADD add_b2 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_a3),.b(mlt_b2),.q(summ_b2));
	
  FP_ADD add_b3 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_b2),.b(mlt_b3),.q(summ_b3));  
  
  always @(sampl)
    begin
	   if (sampl)
		  begin
	       sh_1 = summ_a3;
		    sh_2 = sh_1;
			 o_signal = summ_b3;
		  end
	   else
		  begin
	       sh_1 = sh_1;
		    sh_2 = sh_2;
			 o_signal = o_signal;
		  end
	 end
  
endmodule 