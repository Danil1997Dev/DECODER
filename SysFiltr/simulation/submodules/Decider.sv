module Decider#(parameter 
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
  input clk,reset_l,clk_en,enabel,work,
  input [2:0] address,
  input [31:0] data,
  input [31:0] relax_freq,
  output logic indicate,
  output logic valid
); 
  logic [31:0] range[0:1]; 


  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin  
						range[0] = 0;
						range[1] = 0;
		  end
	else
		  begin
			 if (enabel) 
		 		 begin
						range[address] = data; 
		 		end  
		 	 else
				begin 
						range[address] = range[address];
				end
		end
  end
  
  always_ff @(posedge clk or negedge reset_l)
    begin
	   if (!reset_l)
		  begin  
						indicate <= 1'bx;
						valid <= 1'bx;
		  end
	else
		  begin
			 if ( work ) 
		 		 begin
				   if ((relax_freq >= range[0]) && (relax_freq <= range[1]))
					  begin
						indicate <= 1;
						valid <= 1;
					  end
				   else
					  begin
						indicate <= 0;
						valid <= 0;
					  end 
		 		end  
		 	 else
				begin 
						indicate <= 1'bx;
						valid <= 1'bx;
				end
		end
  end
 
endmodule 