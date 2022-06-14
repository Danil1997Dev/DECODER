set name SysFiltr_tb 

# change dir
set path "D:/intelFPGA/18.1/DECODER/" 
set m mem

set K 600
set WIDTH 20
set SAMPL 25000000
set FRQ 440000
set N [expr "$SAMPL/$FRQ"]
set U [expr "2**($WIDTH-1)"]

if {$m == "mem"} {
	do mem.do
} else { if {$m == "mif"} {
	do mif.do
}}
#############Create work library#############
vlib work
 
# Set the window types
mem load -i $path/software/os/obj/default/runtime/sim/mentor/mema_u.$m /$name/mema_u
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memb_u.$m /$name/memb_u
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memc_u.$m /$name/memc_u

mem load -i $path/software/os/obj/default/runtime/sim/mentor/mema_i.$m /$name/mema_i
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memb_i.$m /$name/memb_i
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memc_i.$m /$name/memc_i
view wave
view structure
view signals
#add wave  
add wave -noupdate -divider {all}
add wave -noupdate sim:/SysFiltr_tb/* 
add wave -noupdate -divider {decoder}
add wave -position insertpoint sim:/SysFiltr_tb/dut/decoder/indicate 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/signal_adc_I
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/signal_adc_U
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/sin
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/cos 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/i_int 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/q_int 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/u_int 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/relax_freq
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/gen_inst/delta 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/small_i 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/small_q  
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/small_u
add wave -noupdate -divider {const}
add wave -noupdate -radix float32 sim:/SysFiltr_tb/dut/decoder/filtr_i_inst/filtr/caff
add wave -noupdate -radix float32 sim:/SysFiltr_tb/dut/decoder/filtr_q_inst/filtr/caff   
add wave -noupdate -radix float32 sim:/$name/dut/decoder/arith_inst/Ku
run -all