module Arith#(parameter 
CLK_REF = 50_000_000,
SAMPL_T = 1_000_000,
FRQ_SIGNAL = 440_000,
FRQ_DELT = 44_000,  

FRQ_SIGNAL_MAX = FRQ_SIGNAL+FRQ_DELT,
FRQ_SIGNAL_MIN = FRQ_SIGNAL-FRQ_DELT,
N_MAX = CLK_REF/FRQ_SIGNAL_MIN,
N_MIN = CLK_REF/FRQ_SIGNAL_MAX,
W_N_MAX = $clog2(N_MAX),
W_N_MIN = $clog2(N_MIN),
T = CLK_REF/SAMPL_T,
N = SAMPL_T/FRQ_SIGNAL)
(
  input clk,reset_l,clk_en,enabel,
  input [2:0] address,
  input [31:0] data,
  input [31:0] i,q,u,
  output logic signed [31:0] signal_o,
  output valid
);
  logic done_rel,done_mult,done_cnv,start,done_mult_i,done_mult_q;
  logic [31:0] relat_signal,mult_signal,abs_signal,o_signal,i_mult,q_mult;
  logic [31:0] Ku;
 
  assign valid = done_cnv && done_mult;


  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin  
				  Ku = 32'b0111111100000000000000000000000;  
		  end
	else
		  begin
			 if (enabel) 
		 		 begin
						Ku = data;
		 		end  
		 	 else
				begin 
		        		Ku = Ku;
				end
		end
  end
  
  Convers mult_i ( .clk(clk), 
	   .clk_en(clk_en), 
	   .dataa(i), 
	   .datab(u),
	   .n(4), 
	   .reset(!reset_l), 
	   .reset_req(0), 
	   .start(start),
	   .done(done_mult_i), 
	   .result( i_mult ));
		
  Convers mult_q ( .clk(clk), 
	   .clk_en(clk_en), 
	   .dataa(q), 
	   .datab(u),
	   .n(4), 
	   .reset(!reset_l), 
	   .reset_req(0), 
	   .start(start),
	   .done(done_mult_q), 
	   .result( q_mult ));

  Convers div ( .clk(clk), 
	   .clk_en(clk_en), 
	   .dataa(i_mult), 
	   .datab(q_mult),
	   .n(7), 
	   .reset(!reset_l), 
	   .reset_req(0), 
	   .start(done_mult_i && done_mult_q),
	   .done(done_rel), 
	   .result( relat_signal ));

  Convers mult ( .clk(clk), 
	   .clk_en(clk_en), 
	   .dataa(relat_signal), 
	   .datab(Ku),
	   .n(4), 
	   .reset(!reset_l), 
	   .reset_req(0), 
	   .start(done_rel),
	   .done(done_mult), 
	   .result( mult_signal ));
		
  FP_ABS	fp_abs_inst (
		.aclr ( !reset_l ),
		.data ( mult_signal ),
		.result ( abs_signal ));

  Convers cnv_o ( .clk(clk), 
	   .clk_en(clk_en), 
	   .dataa(abs_signal), 
	   .datab(0),
	   .n(1), 
	   .reset(!reset_l), 
	   .reset_req(0), 
	   .start(done_mult),
	   .done(done_cnv), 
	   .result( o_signal ));
 
   logic [1:0] buff_reset_l;

  always @(posedge clk)
  begin
    buff_reset_l <= {buff_reset_l[0],reset_l};
    if (buff_reset_l == 2'b01)
    begin
      start <= 1;
    end
    else
    begin
      if (done_rel)
      begin
        start <= 1;
      end
      else
      begin
        start <= 0;
      end
    end
  end
  
  always @(*)
    begin
	   if (!reset_l)
		  begin   
				  signal_o = 0;
		  end
	else
		  begin
			 if (o_signal == 32'b0111_1111_1111_1111_1111_1111_1111_1111 || o_signal == 32'b1000_0000_0000_0000_0000_0000_0000_0000) 
		 		 begin
						signal_o = 0;
		 		end  
		 	 else
				begin 
		        		signal_o = o_signal;
				end
		end
  end
  
endmodule 