module Decoder#(parameter 
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
  input clk,reset_l,writ,work,
  input [4:0] address, 
  input [31:0] data, 
  input signed [31:0] signal_i, 
  output logic indicate
);
  logic [2:0] wr;
  logic clk_en,start,enabel,valid_gen,valid;
  logic signed [31:0] sin,cos,relat_signal,i,q,i_int,q_int,relax_freq_buf,relax_freq;
  logic signed [31:0] small_i,small_q;
  logic signed [63:0] i_chanal,q_chanal;

  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin   
						   wr[0] = 0;
							wr[1] = 0;
							wr[2] = 0;
		  end
	   else
		  begin
		    if (writ)
			   begin
				 case (address[4:3]) 
					 2'b01:begin
								wr[0] = 1'b1;
								wr[1] = 1'b0;
								wr[2] = 1'b0;
								clk_en = clk_en;
								start = start;
								enabel = enabel;
							 end  
					 2'b10:begin
								wr[0] = 1'b0;
								wr[1] = 1'b1; 
								wr[2] = 1'b0;
								clk_en = clk_en;
								start = start;
								enabel = enabel;
							 end  
					 2'b11:begin 
								wr[0] = 1'b0;
								wr[1] = 1'b0;
								wr[2] = 1'b1; 
								clk_en = clk_en;
								start = start;
								enabel = enabel;
							 end  
					 2'b00:begin
								wr[0] = 1'b0;
								wr[1] = 1'b0;
								wr[2] = 1'b0;
								clk_en = data[0];
								start = data[1];
								enabel = data[2];
							 end 
				  endcase
			    end
			  else
			    begin
								wr[0] = 1'b0;
								wr[1] = 1'b0;
								wr[2] = 1'b0; 
								clk_en = clk_en;
								start = start;
								enabel = enabel;
				 end
		end
  end
  
  always @(posedge clk)
	  begin 
	    i_chanal <= sin*signal_i;
		 q_chanal <= cos*signal_i;
		 if (valid)
		   begin
		     relax_freq <= relax_freq_buf;
			end
	    else
		   begin
			  relax_freq <= relax_freq;
			end
	  end  
 
  Generator #(.W_N_MAX(W_N_MAX) ) gen_inst (  .clk(clk), 
		.reset_l   (reset_l),   // rst.reset_n
		.clk_en     (clk_en),     //  in.clken
		.enabel(clk_en),
//	   .address(address[2:0]),
//	   .data(data),
		.signal (signal_i), //    .phi_inc_i
		.sin    (sin),    // out.fsin_o
		.cos    (cos),    //    .fcos_o
		.valid_gen (valid_gen));  //    .out_valid); 
		
  Filtr # (.CLK_REF(CLK_REF), .SAMPL_T(SAMPL_T), .FRQ_SIGNAL(FRQ_SIGNAL)) filtr_i_inst (		.clk       (clk),       // clk.clk
		.reset_l   (reset_l),   // rst.reset_n
		.clk_en     (clk_en),     //  in.clken 
		.enabel(wr[0]),
	   .address(address[2:0]),
		.start(start),
	   .i_signal(i_chanal[63:32]), 
	   .data(data),
	   .o_signal(i),
	   .o_signal_int(i_int)		);

  Filtr # (.CLK_REF(CLK_REF), .SAMPL_T(SAMPL_T), .FRQ_SIGNAL(FRQ_SIGNAL)) filtr_q_inst (		.clk       (clk),       // clk.clk
		.reset_l   (reset_l),   // rst.reset_n
		.clk_en     (clk_en),     //  in.clken 
		.enabel(wr[0]),
	   .address(address[2:0]),
		.start(start),
	   .i_signal(q_chanal[63:32]), 
	   .data(data),
	   .o_signal(q),
	   .o_signal_int(q_int));
		
  Arith arith_inst ( .clk(clk), 
	   .clk_en(clk_en), 
		.enabel(wr[1]),
	   .address(address[2:0]),
	   .data(data),
	   .i(i), 
	   .q(q),
	   .reset_l(reset_l),  
	   .valid(valid), 
	   .signal_o( relax_freq_buf ));
		
  Decider dm_inst ( .clk(clk), 
	   .clk_en(clk_en), 
		.enabel(wr[2]),
	   .address(address[2:0]),
	   .data(data),
	   .relax_freq(relax_freq),
	   .reset_l(reset_l), 
	   .work(work),  
	   .valid( ), 
	   .indicate( indicate ));

  assign small_i = i_chanal[63:32];
  assign small_q = q_chanal[63:32];

endmodule 