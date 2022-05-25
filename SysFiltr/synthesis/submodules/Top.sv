module Top#(parameter 
CLK_REF = 50_000_000,
SAMPL_T = 1_000_000,
FRQ_SIGNAL = 25_000,

T=CLK_REF/SAMPL_T,
N=SAMPL_T/FRQ_SIGNAL)
(
  input clk,reset_l,clk_en,start,enabel,
  input [2:0]opt_i,opt_o, 
  input [2:0] address,
  input [31:0] i_signal, data,
  output logic [31:0] o_signal  
);

  bit done;
  bit [31:0] signal_int_i,signal_doubal_i;
  bit [31:0] signal_int_o,signal_doubal_o; 
  bit start_f;       
  logic [0:1] [32:0] buffer;

  enum int unsigned{
	  Reset_St = 0, 
	  Count_St = 1,
	  Wait_St = 2 
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
			Reset_St:    begin   
   if (!reset_l)
    begin
			 start_f = 0; 
		    signal_doubal_i = 0; 
			 signal_int_i = 0;
		    next_state = Reset_St;
    end
  else
    begin 
			 start_f = 0; 
		    signal_doubal_i = 0; 
			 signal_int_i = 0;
		    next_state = Wait_St;
    end
							end    
		  Wait_St:begin
    if (!reset_l)
    begin
     start_f = 0; 
		    signal_doubal_i = 0; 
		    signal_int_i = 0;
		    next_state = Reset_St;
    end
  else
    begin 
      buffer <= {buffer [0],signal_doubal_o};
      case ( buffer )
        64'b0100011110000000000000000000000000000000000000000000000000000000:   begin 
			 start_f = 0; 
		    signal_doubal_i = 0; 
			 signal_int_i = 0;
   		 next_state = Wait_St;
	end
        64'b0100011110000000000000000000000001000111100000000000000000000000:   begin 
			 start_f = 0; 
		    signal_doubal_i = 0; 
			 signal_int_i = 0;
   		 next_state = Wait_St;
	end
        64'b0000000000000000000000000000000001000111100000000000000000000000:    begin
			 start_f = 0;
		    signal_doubal_i = 0; 
			 signal_int_i = 0;
   		 next_state = Wait_St;
	end
        default:  																				   begin
			 start_f = 0;		   
			 signal_doubal_i = 0;
			 signal_int_i = 0;
			 next_state = Count_St;
	end
      endcase 
    end
							end  
			Count_St:		begin
   if (!reset_l)
    begin
		    start_f = 0; 
		    signal_doubal_i = 0; 
		    signal_int_i = 0;
		    next_state = Reset_St;
    end
  else
    begin 
		    start_f = 1;		   
		    signal_doubal_i = signal_doubal_o;
		    signal_int_i = signal_int_o;
		    next_state = Count_St;
    end
		 end
		 endcase
	  end

  Convers cnv_i ( .clk(clk), .clk_en(clk_en), .dataa(i_signal), .datab(0), .n(opt_i), .reset(!reset_l), .reset_req(0), .start(start), .done(done), .result( signal_doubal_o ));	  
  IIR_Filtr #(.T(T),.N(N)) filtr ( .clk(clk), .i_signal(signal_doubal_i),.address(address),.data(data),.enabel(enabel),.start(start_f), .reset_l(reset_l), .i_en(done), .o_signal( signal_int_o ));
  Convers cnv_o ( .clk(clk), .clk_en(clk_en), .dataa(signal_int_i), .datab(0), .n(opt_o), .reset(!reset_l), .reset_req(0), .start(start), .result( o_signal ));
endmodule 