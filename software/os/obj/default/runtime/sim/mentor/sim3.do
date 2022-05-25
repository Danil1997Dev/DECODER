set name SysFiltr_tb
set pathQuartus "K:/intelfpga_lite/18.1/quartus/"
set path "D:/intelFPGA/18.1/NIOS_IIR/software/os/obj/default/runtime/sim/mentor" 
set pathSUB "Decoder/NCO/simulation"
set m mem

set K 1
set N100 [expr "50000000/440000"]
set N50 [expr "25000000/440000"]
set N5 [expr "5000000/440000"]

if {$m == "mem"} {
	do mem.do
} else { if {$m == "mif"} {
	do mif.do
}} 
#############Create work library#############
vlib work
 
# Set the window types
mem load -i $path/mem_100_a.$m /$name/mem_100_a 
mem load -i $path/mem_100_b.$m /$name/mem_100_b
mem load -i $path/mem_100_c.$m /$name/mem_100_c
mem load -i $path/mem_50_a.$m /$name/mem_50_a 
mem load -i $path/mem_50_b.$m /$name/mem_50_b
mem load -i $path/mem_50_c.$m /$name/mem_50_c
mem load -i $path/mem_5_a.$m /$name/mem_5_a 
mem load -i $path/mem_5_b.$m /$name/mem_5_b
mem load -i $path/mem_5_c.$m /$name/mem_5_c
view wave
view structure
view signals
#add wave 
add wave -noupdate -divider {__________50_M___________}
add wave -noupdate -divider {all}
add wave -noupdate -radix decimal sim:/$name/* 
add wave -noupdate -divider {dut}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/* 
add wave -noupdate -divider {decoder}
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_100_inst/decoder/*
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_100_inst/decoder/filtr_i_inst/filtr/caff
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_100_inst/decoder/filtr_q_inst/filtr/caff
add wave -noupdate -divider {gen_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/decoder/gen_inst/*
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/gen_inst/fll_inst/*
add wave -noupdate -divider {filtr_i_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/decoder/filtr_i_inst/*  
add wave -noupdate -divider {filtr_q_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/decoder/filtr_q_inst/* 
add wave -noupdate -divider {arith_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/decoder/arith_inst/*   
add wave -noupdate -radix float32 sim:/$name/sysfiltr_100_inst/decoder/arith_inst/Ku
add wave -noupdate -divider {__________25_M___________}
add wave -noupdate -divider {all}
add wave -noupdate -radix decimal sim:/$name/* 
add wave -noupdate -divider {dut}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/* 
add wave -noupdate -divider {decoder}
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/*
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/filtr_i_inst/filtr/caff
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/filtr_q_inst/filtr/caff
add wave -noupdate -divider {gen_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/decoder/gen_inst/*  
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/gen_inst/fll_inst/*
add wave -noupdate -divider {filtr_i_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/decoder/filtr_i_inst/*  
add wave -noupdate -divider {filtr_q_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/decoder/filtr_q_inst/* 
add wave -noupdate -divider {arith_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/decoder/arith_inst/*   
add wave -noupdate -radix float32 sim:/$name/sysfiltr_50_inst/decoder/arith_inst/Ku
add wave -noupdate -divider {__________5_M___________}
add wave -noupdate -divider {all}
add wave -noupdate -radix decimal sim:/$name/* 
add wave -noupdate -divider {dut}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/* 
add wave -noupdate -divider {decoder}
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_5_inst/decoder/*
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_5_inst/decoder/filtr_i_inst/filtr/caff
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_5_inst/decoder/filtr_q_inst/filtr/caff
add wave -noupdate -divider {gen_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/decoder/gen_inst/*
add wave -position insertpoint sim:/SysFiltr_tb/sysfiltr_50_inst/decoder/gen_inst/fll_inst/*  
add wave -noupdate -divider {filtr_i_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/decoder/filtr_i_inst/*  
add wave -noupdate -divider {filtr_q_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/decoder/filtr_q_inst/* 
add wave -noupdate -divider {arith_inst}
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/decoder/arith_inst/*   
add wave -noupdate -radix float32 sim:/$name/sysfiltr_5_inst/decoder/arith_inst/Ku
run -all

#00110110011110010111001001101100
#00110110111110010111001001101100