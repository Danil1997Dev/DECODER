module IIR_Filtr#(parameter T=50_000_000/1_000_000,N=1_000_000/440_000)
(
  input clk,reset_l,i_en, start,enabel,
  input [2:0] address,
  input [31:0] i_signal, data,
  output logic [31:0] o_signal  
);

  logic en = 1;
  
  int cnt;
  logic sampl;  
  
  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin 
		    cnt <= 0;
			 sampl <= 0;
		  end
	else
		  begin
			 if (start) 
		 		 begin
		   			 if (cnt == T)
			  			 begin
		        					cnt <= 0; 
							sampl <= 1;
						end 
		   			 else 
			  			 begin
		       					 cnt <= cnt + 1; 
							 sampl <= 0;
						end 
		 		end  
		 	 else
				begin 
		        			cnt <= 0;
					sampl <= 0;
				end
		end
  end
  
  logic [31:0] caff [0:4];
  
  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin 
		    for (int i=0;i<=4;i++)
			   begin
				  caff[address] = 0; 
				end
		  end
	else
		  begin
			 if (enabel) 
		 		 begin
						caff[address] = data;
		 		end  
		 	 else
				begin 
		        		caff[address] = caff[address];
				end
		end
  end
//  const logic [31:0] S1 =  32'b00110110111111001011100100110110; 
//  const logic [31:0] A12 = 32'b00110111011111001011100100110110; 
//  const logic [31:0] A13 = 32'b00110110111111001011100100110110; 
//  const logic [31:0] B12 = {1'b1,8'b1111111,23'b11111101011100001010001}; 
//  const logic [31:0] B13 = 32'b00111111011111010111000010100010;
//  
//  const logic [31:0] OUT = 32'b01000111110000110101000000000000;
  
//  const logic [31:0] S1 = {1'b0,8'b1111001,23'b11101011100001010000000};
//  const logic [31:0] A12 = {1'b1,8'b1111111,23'b01111010111000010100011}; 
//  const logic [31:0] A13 = {1'b0,8'b1111110,23'b11010111000010100011110}; 
//  const logic [31:0] B12 = {1'b11,8'b1111110,23'b11111010111000010100010};//{1'b1,8'b1111011,23'b01110000101000111100000} 
//  const logic [31:0] B13 = {1'b0,8'b1111110,23'b00000000000000000000000}; //{1'b0,8'b1111110,23'b11111010111000010100010}; {1'b0,8'b1111011,23'b01110000101000111100000};
 
  
 
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
  bit [31:0] out_mult = 0; 
  
  FP_MULT  mult_s (.clk(clk),.areset(~reset_l),.en(en),.a(i_signal),.b(caff[0]),.q(mlt_s));
  
  FP_SUB sub_a2 (.clk(clk),.areset(~reset_l),.en(en),.a(mlt_s),.b(mlt_a2),.q(summ_a2));
  
  FP_SUB sub_a3 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_a2),.b(mlt_a3),.q(summ_a3)); 
  
  FP_MULT  mult_a2 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_1),.b(caff[1]),.q(mlt_a2));
  
  FP_MULT  mult_b2 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_1),.b(caff[3]),.q(mlt_b2)); 
  
  FP_MULT  mult_b3 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_2),.b(caff[4]),.q(mlt_b3)); 
  
  FP_MULT  mult_a3 (.clk(clk),.areset(~reset_l),.en(en),.a(sh_2),.b(caff[2]),.q(mlt_a3));
  
  FP_ADD add_b2 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_a3),.b(mlt_b2),.q(summ_b2));
	
  FP_ADD add_b3 (.clk(clk),.areset(~reset_l),.en(en),.a(summ_b2),.b(mlt_b3),.q(summ_b3)); 
 
  FP_MULT  mult_out (.clk(clk),.areset(~reset_l),.en(en),.a(summ_b3),.b(OUT),.q(out_mult)); 
  
  always @(sampl) 
//    begin
//	   if (summ_b3 == 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz)
//		 begin
//			if (sampl)
//			  begin
//				 sh_1 <= summ_a3;
//				 sh_2 <= sh_1;
//				 o_signal = 0; 
//			  end
//		 end
//		else
		 begin
			if (sampl)
			  begin
				 sh_1 <= summ_a3;
				 sh_2 <= sh_1;
				 o_signal = summ_b3;
			  end
			else
			  begin
				 sh_1 <= sh_1;
				 sh_2 <= sh_2;
				 o_signal = o_signal;
			  end
		 end
	// end
  
endmodule 