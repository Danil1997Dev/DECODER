set name SysFiltr_tb 

# change dir
set path "D:/intelFPGA/18.1/DECODER/" 
set m mem

set K 350
set CLK 50000000
set FRQ 440000
set N [expr "$CLK/$FRQ"]

if {$m == "mem"} {
	do mem.do
} else { if {$m == "mif"} {
	do mif.do
}} 
#############Create work library#############
vlib work
 
# Set the window types
mem load -i $path/software/os/obj/default/runtime/sim/mentor/mema.$m /$name/mema 
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memb.$m /$name/memb
mem load -i $path/software/os/obj/default/runtime/sim/mentor/memc.$m /$name/memc
view wave
view structure
view signals
#add wave  
add wave -noupdate -divider {all}
add wave -noupdate sim:/SysFiltr_tb/* 
add wave -noupdate -divider {decoder}
add wave -position insertpoint sim:/SysFiltr_tb/dut/decoder/indicate 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/signal_i 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/sin
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/cos 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/i_int 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/q_int 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/relax_freq
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/gen_inst/delta 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/small_i 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/small_q 
add wave -radix decimal sim:/SysFiltr_tb/dut/decoder/gen_inst/delta  
add wave -noupdate -divider {const}
add wave -noupdate -radix float32 sim:/SysFiltr_tb/dut/decoder/filtr_i_inst/filtr/caff
add wave -noupdate -radix float32 sim:/SysFiltr_tb/dut/decoder/filtr_q_inst/filtr/caff   
add wave -noupdate -radix float32 sim:/$name/dut/decoder/arith_inst/Ku
run -all

#00110110011110010111001001101100
#00110110111110010111001001101100