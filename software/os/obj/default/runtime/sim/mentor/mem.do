
set pi 3.14159265359  

set fileid [open "mema_u.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N)*$i-2*$pi/(2*$N)-5*$pi/(6)-2*$pi)"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "memb_u.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N*1.02)*$i-2*$pi/(2*$N*1.02))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "memc_u.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N*0.98)*$i-2*$pi/(2*0.98*$N))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 
set fileid [open "mema_i.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N)*$i-2*$pi/(2*$N)-2*$pi/(6)-5*$pi/(6)-2*$pi)"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "memb_i.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N*1.02)*$i-2*$pi/(2*$N*1.02)+2*$pi/(6))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

set fileid [open "memc_i.mem" w+]

seek $fileid 0 current
puts $fileid "// memory data file (do not edit the following line - required for mem load use)
// instance=/TOP/mem
// format=mti addressradix=d dataradix=d version=1.0 wordsperline=1"
for {puts "Start"; set i 0} {$i < [expr "($K)*$N"]} {incr i;} {
 set Y [expr "$U*sin(2*$pi/($N*0.98)*$i-2*$pi/(2*0.98*$N)-2*$pi/(6))"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i: $D"; }
 
 close $fileid 

#+100*sin(2*$pi/(5*$N)*$i-2*$pi/(5*2*$N))+50*sin(2*$pi/(10*$N)*$i-2*$pi/(10*2*$N))