
set pi 3.14159265359
set U 100000000
set fileid [open "mem_100_a.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N100"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N100)*$i-2*$pi/(2*$N100))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_100_b.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N100"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N100*1.02)*$i-2*$pi/(2*$N100*1.02))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_100_c.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N100"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N100*0.98)*$i-2*$pi/(2*0.98*$N100))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 


set fileid [open "mem_50_a.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N50"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N50)*$i-2*$pi/(2*$N50))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_50_b.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N50"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N50*1.02)*$i-2*$pi/(2*$N50*1.02))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_50_c.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N50"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N50*0.98)*$i-2*$pi/(2*0.98*$N50))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_5_a.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N5"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N5)*$i-2*$pi/(2*$N5))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_5_b.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N5"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N5*1.02)*$i-2*$pi/(2*$N5*1.02))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "mem_5_c.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N5"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N5*0.98)*$i-2*$pi/(2*0.98*$N5))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 
#+100*sin(2*$pi/(5*$N)*$i-2*$pi/(5*2*$N))+50*sin(2*$pi/(10*$N)*$i-2*$pi/(10*2*$N))