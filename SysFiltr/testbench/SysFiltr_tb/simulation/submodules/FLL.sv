module FLL#(parameter 
W_N_MAX = 50_000_000)
(
  input clk,reset_l,clk_en,start,enabel,
  input signed [31:0] signal_input, signal_gen,
  output logic signed [31:0] delta,
  output logic ph_en ,vg,vi,blok
);
 
  logic valid_gen,valid_input,valid_sub,rst,cnt_in,cnt_gen,pm_in,pm_gen,ph_in,ph_gen,valid_sub_en,valid_delta,en_hold,cnt_hold,ph_pm_in,ph_pm_gen,valid_ph_delta,pm_in_buf;
  logic [1:0] chk;
  logic [2:0] buf_pm_in,buf_pm_gen;
  logic [W_N_MAX-1:0] count_input,count_gen,count_buf;
 
  enum int unsigned{
	  Reset_St = 0, 
	  Wait_St = 1,
	  Count_St = 2,
	  Step_St = 3,
	  Chek_St = 4,
	  Hold_fst_St = 5,
	  Hold_sec_St = 6 
  } state,next_state;


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
			Reset_St:  begin   
							 if (!reset_l)
							   begin   
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Reset_St;
							   end
							 else
							   begin  
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Wait_St;
							   end
							end    
			Wait_St:   begin
							 if (!reset_l)
							   begin
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Reset_St;
							   end
							 else
							   begin
								  if (chk == 1 && !(ph_pm_in && ph_pm_gen))
								    begin 
									   cnt_hold = 0;
									   en_hold = 1;
									   count_buf = 0;
										blok = 0;
								      next_state = Count_St;
									 end
								  else
								    begin 
									   cnt_hold = 0;
									   en_hold = en_hold;
									   count_buf = 0;
										blok = 0;
								      next_state = Wait_St;
									 end
							   end
						  end  
			Count_St:  begin
							 if (!reset_l)
							   begin 
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Reset_St;
							   end
							 else
							   begin
								  if (((count_input == count_gen) && (count_input != 0) && (count_gen != 0)))
								    begin
									   if (pm_in_buf && pm_gen)
										  begin
									       cnt_hold = 1;
									       en_hold = en_hold;
									       count_buf = count_gen;
									       blok = 0;
									       next_state = Step_St;
										  end
									   else if (!pm_in_buf && pm_gen)
										  begin
									       cnt_hold = 1;
									       en_hold = en_hold;
									       count_buf = count_gen;
									       blok = 0;
									       next_state = Step_St;
										  end
									   else
										  begin
									       cnt_hold = 0;
									       en_hold = 0;
									       count_buf = 0;
									       blok = 0;
									       next_state = Wait_St;
										  end
									 end
								  else
								    begin
									   cnt_hold = 0;
									   en_hold = en_hold;
									   count_buf = count_buf;
										blok = 0;
								      next_state = Count_St;
									 end
							   end
						  end
			Step_St:  begin
							 if (!reset_l)
							   begin 
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Reset_St;
							   end
							 else
							   begin
								  if (chk == 1)
								    begin
									   cnt_hold = cnt_hold;
									   en_hold = en_hold;
									   count_buf = count_buf;
										blok = 0;
								      next_state = Chek_St;
									 end
								  else if (chk == 2)
								    begin
									   cnt_hold = 0;
									   en_hold = 0;
									   count_buf = 0;
										blok = 0;
								      next_state = Wait_St;
									 end
								  else
								    begin
									   cnt_hold = cnt_hold;
									   en_hold = en_hold;
									   count_buf = count_buf;
										blok = 0;
								      next_state = Step_St;
									 end
							   end
						  end
			Chek_St:  begin
							 if (!reset_l)
							   begin 
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
								  blok = 0;
								  next_state = Reset_St;
							   end
							 else
							   begin
								  if (count_input == count_buf)
								    begin
									   cnt_hold = 1;
									   en_hold = 1;
									   count_buf = count_buf;
										blok = 0;
								      next_state = Hold_fst_St;
									 end
								  else if (chk == 2)
								    begin
									   cnt_hold = 0;
									   en_hold = 0;
									   count_buf = 0;
										blok = 0;
								      next_state = Wait_St;
									 end
								  else
								    begin
									   cnt_hold = cnt_hold;
									   en_hold = en_hold;
									   count_buf = count_buf;
										blok = 0;
								      next_state = Chek_St;
									 end
							   end
						  end 
			Hold_fst_St:  begin
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
							     blok = 1;
							     next_state = Hold_sec_St;
						  end 
			Hold_sec_St:  begin
								  cnt_hold = 0;
								  en_hold = 0;
								  count_buf = 0;
							     blok = 1;
							     next_state = Wait_St;
						  end 
		 endcase
	  end
	  
  always@( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
			   buf_pm_in <= 0;
				buf_pm_gen <= 0; 
				//ph_pm_in <= 0;
				//ph_pm_gen <= 0; 
				//valid_ph_delta <= 0;
			end
		 else 
		   begin
			   buf_pm_in <= {buf_pm_in[1:0],pm_in};
				buf_pm_gen <= {buf_pm_gen[1:0],pm_gen}; 
				//ph_pm_in <= buf_pm_in[0] || buf_pm_in[1] || buf_pm_in[2];
				//ph_pm_gen <= buf_pm_gen[0] || buf_pm_gen[1] || buf_pm_gen[2]; 
				//valid_ph_delta <= ph_pm_in && ph_pm_gen;
			end
	  end
	  
  always_comb
	  begin
				ph_pm_in = buf_pm_in[0] || buf_pm_in[1] || buf_pm_in[2];
				ph_pm_gen = buf_pm_gen[0] || buf_pm_gen[1] || buf_pm_gen[2]; 
				if (cnt_in || cnt_gen)
				  begin
				    if (pm_in)
					   begin
						  pm_in_buf = 1;
						end
				    else
					   begin
						  pm_in_buf = pm_in_buf;
						end
				  end
				else
				  begin 
					   begin
						  pm_in_buf = 0;
						end 
				  end
	  end
	  
  always@( posedge clk or negedge reset_l )
	  begin
		 if ( !reset_l ) 
			begin
				valid_sub <=  0;
				valid_delta <= 0;
			end
		 else 
		   begin 
				valid_sub <= valid_input && valid_gen;
				valid_delta <= valid_sub;
			end
	  end
	  
  always_comb
	  begin
		 if ( !reset_l ) 
			begin
				chk =  0;
			end
		 else 
		   begin
				if (valid_delta)
				  begin
				    if (((delta <= 1) && (delta >= -1)))
					   begin
						  chk = 1;
						end 
				    else 
					   begin
						  chk = 2;
						end
				  end
				else
				  begin
				    chk = 0;
				  end
			end
	  end
  
 
 
  ENUM_CNT #(.W_N_MAX(W_N_MAX),.LIMIT(0) ) enum_cnt_input_inst ( .clk(clk), .enabel(1), .reset_l(reset_l), .signal_in(signal_input), .count(count_input), .valid(valid_input), .rst(valid_sub),.pm_o(pm_in),.ph_en(ph_in),.ph_cnt(ph_cnt_in),.cnt_o(cnt_in));
  ENUM_CNT #(.W_N_MAX(W_N_MAX),.LIMIT(0) ) enum_cnt_gen_inst ( .clk(clk), .enabel(1), .reset_l(reset_l), .signal_in(signal_gen), .count(count_gen), .valid(valid_gen), .rst(valid_sub),.pm_o(pm_gen),.ph_en(ph_gen),.ph_cnt( ),.cnt_o(cnt_gen));
  SUB_CNT  #(.WIDTH(W_N_MAX) ) sub_cnt_inst ( .clk(clk), .valid(valid_sub), .reset_l(reset_l), .count_gen(count_gen), .count_input(count_input), .delta(delta) ); 
 
  assign vi = valid_input;
  assign vg = valid_gen;
  
  assign ph_en = cnt_hold;
  
endmodule 