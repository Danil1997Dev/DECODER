module Generator#(parameter 
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
  input clk,reset_l,clk_en,start,enabel,
  input [2:0] address, 
  input [31:0] data,
  input signed [31:0] signal, 
  output logic [31:0] sin,cos,
  output logic valid_gen
);
  
  logic [31:0] phi = 36_151_557;
  logic signed [31:0] delta = 0;
  logic signed [63:0] sub = 0;
  const logic signed [31:0] MULT = 300_000;
  
  always @(posedge clk)
	  begin 
	    sub <= MULT*delta;
	    phi <= phi - sub[31:0];//sub[63:32] 250_000*delta
	  end  
 
  FLL #(.W_N_MAX(W_N_MAX) ) fll_inst (  .clk(clk), 
																	.enabel(enabel), 
																	.reset_l(reset_l), 
																	.signal_input(signal),
																	.signal_gen(sin),
																	.delta(delta));
  NCO nco_inst (		.clk       (clk),       // clk.clk
		.reset_n   (reset_l),   // rst.reset_n
		.clken     (enabel),     //  in.clken
		.phi_inc_i (phi), //    .phi_inc_i
		.fsin_o    (sin),    // out.fsin_o
		.fcos_o    (cos),    //    .fcos_o
		.out_valid (valid_gen));  //    .out_valid); 
endmodule 