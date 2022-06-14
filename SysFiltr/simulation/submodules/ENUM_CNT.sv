module ENUM_CNT#(parameter
LIMIT = -5,
W_N_MAX = 1 )
(
  input clk,reset_l,enabel,rst,
  input signed [31:0] signal_in,
  output valid,pm_o,cnt_o,
  output logic ph_en,ph_cnt_en,
  output logic [1:0] ph_cnt,
  output logic [W_N_MAX-1:0] count  
);  
  logic cnt,hold;    
  logic signed [1:0] [31:0] buff_signal = 0;
  logic signed [31:0] buff_signal_fst = 0;
  logic signed [31:0] buff_signal_sec = 0;
  logic [1:0]			buff_start_cnt = 0;
  logic pm;
  logic r; 
  logic nul;
  
  enum int unsigned{
	  Reset_St = 0, 
	  Count_St = 1,
	  Wait_St = 2,
	  Hold_fst_St = 3,
	  Hold_sec_St = 4
  } state,next_state;

  assign pm_o = (buff_signal_fst <= LIMIT && buff_signal_sec > LIMIT);
  assign pm = (buff_signal_fst <= LIMIT && buff_signal_sec > LIMIT);
  assign nul = ((buff_signal_fst == 0) && (buff_signal_sec == 0));
  assign r = rst;
  assign cnt_o = cnt;

  always@( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
				state  <=  Reset_St;
			end
		 else 
			begin 
				state  <=  next_state;
			end
	  end
	  
  always @(*)
	  begin 
		 unique case( state )
			Reset_St: begin   
		if (!reset_l)
		 begin  
				 cnt = 0; 
				 hold = 0; 
				 ph_en = 0;
			    ph_cnt_en = 0;	 
				 next_state = Reset_St;
		 end
	  else
		 begin   
				 cnt = 0; 
				 hold = 1;
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Wait_St;
		 end
						 end    
		  Wait_St:   begin
		 if (!reset_l || nul)
			 begin 
				 cnt = 0; 
				 hold = 1; 
				 ph_en = 0;
			    ph_cnt_en = 0;	 
				 next_state = Reset_St;
			 end
		 else
			 begin  
				if ( pm )
				  begin 
				 cnt = 1; 
				 hold = 1; 
				 ph_en = 0;
			    ph_cnt_en = 0;	 
				 next_state = Count_St;
				  end
				else
				  begin 
				 cnt = 0; 
				 hold = 1;  
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Wait_St;
				  end 
		 end
						  end
			Count_St:  begin
		if (!reset_l || nul)
		 begin
				 cnt = 0; 
				 hold = 0; 
				 ph_en = 0;
			    ph_cnt_en = 0;	 
				 next_state = Reset_St;
		 end
	  else
		 begin 
			if ( pm )
					  begin 
				 cnt = 1; 
				 hold = 0;  
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Hold_fst_St;
					  end
					else
					  begin 
				 cnt = 1; 
				 hold = 1; 
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Count_St;
					  end
		 end
						  end
		  Hold_fst_St:   begin
		 if (!reset_l || nul)
			 begin 
				 cnt = 0; 
				 hold = 0; 
				 ph_en = 0;
			    ph_cnt_en = 0;	 
				 next_state = Reset_St;
			 end
		 else
			 begin  
				if (rst)
				  begin 
				 cnt = 0; 
				 hold = 1;  
				 ph_en = 1; 
			    ph_cnt_en = 1;	 
				 next_state = Wait_St;
				  end
				else if ( pm )
				  begin 
				 cnt = 1; 
				 hold = 0; 
				 ph_en = 0; 
			    ph_cnt_en = 0;	 
				 next_state = Hold_sec_St;
				  end 
				else
				  begin 
				 cnt = 1; 
				 hold = 0;  
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Hold_fst_St;
				  end 
		 end
						  end
		  Hold_sec_St:   begin
		 if (!reset_l || nul)
			 begin 
				 cnt = 0; 
				 hold = 0;
				 ph_en = 0;
			    ph_cnt_en = 0; 
				 next_state = Reset_St;
			 end
		 else
			 begin  
				if ( pm )
				  begin 
				 cnt = 0; 
				 hold = 1; 
				 ph_en = 0; 
				 ph_cnt_en = 1;
				 next_state = Wait_St;
				  end
				else
				  begin 
				 cnt = 1; 
				 hold = 0;
				 ph_en = 1;	
			    ph_cnt_en = 0; 
				 next_state = Hold_sec_St;
				  end 
		 end
						  end
		 endcase
	  end

  always_comb 
//    begin
//	   if (!reset_l)
//		  begin
//		    buff_signal = 0;
//		  end
//		else
		  begin
		    //buff_start_cnt <= {buff_start_cnt[0],en}; 
	    buff_signal = {buff_signal[0],signal_in};
	    buff_signal_fst = buff_signal[1];
	    buff_signal_sec = buff_signal[0];
//		    unique case (buff_start_cnt)
//			   2'b01:   begin
//								cnt_en = 1;
//								valid = 0;
//					      end
//			   2'b10:   begin
//								cnt_en = 0;
//								valid = 1;
//					      end
//			   default: begin
//								cnt_en = cnt_en;
//								valid = valid;
//					      end
//			 endcase
		  end  
//	 end 

  always @( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
				ph_cnt  <=  0;
			end
		 else 
			begin 
				ph_cnt  <=  ph_cnt + ph_cnt_en;
			end
	  end
  assign valid = ~hold;
  COUNT #(.WIDTH(W_N_MAX) ) cnt_inst ( .clk(clk), .cnt_en((cnt || !hold) && enabel), .reset_l(reset_l), .enable(hold), .count(count) );	  
endmodule 