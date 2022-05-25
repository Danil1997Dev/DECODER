# Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	SysFiltr_cpu_cpu 	SysFiltr_cpu_cpu:*
set 	SysFiltr_cpu_cpu_oci 	SysFiltr_cpu_cpu_nios2_oci:the_SysFiltr_cpu_cpu_nios2_oci
set 	SysFiltr_cpu_cpu_oci_break 	SysFiltr_cpu_cpu_nios2_oci_break:the_SysFiltr_cpu_cpu_nios2_oci_break
set 	SysFiltr_cpu_cpu_ocimem 	SysFiltr_cpu_cpu_nios2_ocimem:the_SysFiltr_cpu_cpu_nios2_ocimem
set 	SysFiltr_cpu_cpu_oci_debug 	SysFiltr_cpu_cpu_nios2_oci_debug:the_SysFiltr_cpu_cpu_nios2_oci_debug
set 	SysFiltr_cpu_cpu_wrapper 	SysFiltr_cpu_cpu_debug_slave_wrapper:the_SysFiltr_cpu_cpu_debug_slave_wrapper
set 	SysFiltr_cpu_cpu_jtag_tck 	SysFiltr_cpu_cpu_debug_slave_tck:the_SysFiltr_cpu_cpu_debug_slave_tck
set 	SysFiltr_cpu_cpu_jtag_sysclk 	SysFiltr_cpu_cpu_debug_slave_sysclk:the_SysFiltr_cpu_cpu_debug_slave_sysclk
set 	SysFiltr_cpu_cpu_oci_path 	 [format "%s|%s" $SysFiltr_cpu_cpu $SysFiltr_cpu_cpu_oci]
set 	SysFiltr_cpu_cpu_oci_break_path 	 [format "%s|%s" $SysFiltr_cpu_cpu_oci_path $SysFiltr_cpu_cpu_oci_break]
set 	SysFiltr_cpu_cpu_ocimem_path 	 [format "%s|%s" $SysFiltr_cpu_cpu_oci_path $SysFiltr_cpu_cpu_ocimem]
set 	SysFiltr_cpu_cpu_oci_debug_path 	 [format "%s|%s" $SysFiltr_cpu_cpu_oci_path $SysFiltr_cpu_cpu_oci_debug]
set 	SysFiltr_cpu_cpu_jtag_tck_path 	 [format "%s|%s|%s" $SysFiltr_cpu_cpu_oci_path $SysFiltr_cpu_cpu_wrapper $SysFiltr_cpu_cpu_jtag_tck]
set 	SysFiltr_cpu_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $SysFiltr_cpu_cpu_oci_path $SysFiltr_cpu_cpu_wrapper $SysFiltr_cpu_cpu_jtag_sysclk]
set 	SysFiltr_cpu_cpu_jtag_sr 	 [format "%s|*sr" $SysFiltr_cpu_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$SysFiltr_cpu_cpu_oci_break_path|break_readreg*] -to [get_keepers *$SysFiltr_cpu_cpu_jtag_sr*]
set_false_path -from [get_keepers *$SysFiltr_cpu_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$SysFiltr_cpu_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$SysFiltr_cpu_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$SysFiltr_cpu_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$SysFiltr_cpu_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$SysFiltr_cpu_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$SysFiltr_cpu_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$SysFiltr_cpu_cpu_jtag_sr*]
set_false_path -from *$SysFiltr_cpu_cpu_jtag_sr*    -to *$SysFiltr_cpu_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$SysFiltr_cpu_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$SysFiltr_cpu_cpu_oci_debug_path|monitor_go
