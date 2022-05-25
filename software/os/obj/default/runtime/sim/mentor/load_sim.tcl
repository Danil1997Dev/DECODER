# ------------------------------------------------------------------------------
# Top Level Simulation Script to source msim_setup.tcl
# ------------------------------------------------------------------------------
set QSYS_SIMDIR obj/default/runtime/sim
source msim_setup.tcl
# Copy generated memory initialization hex and dat file(s) to current directory
file copy -force D:/intelFPGA/18.1/NIOS_IIR/software/os/mem_init/hdl_sim/SysFiltr_ram.dat ./ 
file copy -force D:/intelFPGA/18.1/NIOS_IIR/software/os/mem_init/SysFiltr_ram.hex ./ 
