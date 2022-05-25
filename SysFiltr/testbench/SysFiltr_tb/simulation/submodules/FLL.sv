module FLL#(parameter 
W_N_MAX = 50_000_000)
(
  input clk,reset_l,clk_en,start,enabel,
  input signed [31:0] signal_input, signal_gen,
  output logic signed [31:0] delta,
  output logic valid_sub_en 
);

  logic valid_gen,valid_input,valid_sub,rst;
  logic [W_N_MAX-1:0] count_input,count_gen;
// 
//  enum int unsigned{
//	  Reset_St = 0, 
//	  Wait_St = 1,
//	  Relax_St = 2 
//  } state,next_state;
//
//
//  always@( posedge clk or negedge reset_l )
//	  begin
//		 if ( !reset_l ) 
//			begin
//				state  <=  Reset_St;
//			end
//		 else 
//			begin 
//				state  <=  next_state;
//			end
//	  end
//	  
//  always @(*)
//	  begin
//		 unique case( state )
//			Reset_St:  begin   
//							 if (!reset_l)
//							   begin  
//							     valid_sub_en = 0;	
//								  next_state = Reset_St;
//							   end
//							 else
//							   begin  
//								  valid_sub_en = 0;
//								  next_state = Wait_St;
//							   end
//							end    
//			Wait_St:   begin
//							 if (!reset_l)
//							   begin 
//								  valid_sub_en = 0;
//								  next_state = Reset_St;
//							   end
//							 else
//							   begin 
//								  if (valid_gen && valid_input)
//								    begin
//									   valid_sub_en = 1;
//								      next_state = Relax_St;
//									 end
//								  else
//								    begin
//									   valid_sub_en = 0;
//								      next_state = Wait_St;
//									 end
//							   end
//						  end  
//			Relax_St:  begin
//								  valid_sub_en = 0;
//								  next_state = Reset_St;
//						  end
//		 endcase
//	  end
//	  
  always@( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
				valid_sub <=  0;
			end
		 else 
		   begin
				valid_sub <= valid_input && valid_gen;
			end
	  end
 
  ENUM_CNT #(.W_N_MAX(W_N_MAX),.LIMIT(-52000) ) enum_cnt_input_inst ( .clk(clk), .enabel(enabel), .reset_l(reset_l), .signal_in(signal_input), .count(count_input), .valid(valid_input), .rst(valid_sub));
  ENUM_CNT #(.W_N_MAX(W_N_MAX),.LIMIT(0) ) enum_cnt_gen_inst ( .clk(clk), .enabel(enabel), .reset_l(reset_l), .signal_in(signal_gen), .count(count_gen), .valid(valid_gen), .rst(valid_sub)); 
  SUB_CNT  #(.WIDTH(W_N_MAX) ) sub_cnt_inst ( .clk(clk), .valid(valid_sub), .reset_l(reset_l), .count_gen(count_gen), .count_input(count_input), .delta(delta) ); 
endmodule 