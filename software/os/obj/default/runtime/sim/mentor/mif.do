
set fileid [open "testfile.mif" w+]

seek $fileid 0 current
puts $fileid "WIDTH=32;
DEPTH=$N;

ADDRESS_RADIX=DEC;
DATA_RADIX=DEC;

CONTENT BEGIN
"
for {puts "Start"; set i 0} {$i < $N} { set Y [expr "500*sin(2*$pi/10*$i-2*$pi/20)"];set D [expr int($Y)];puts $Y;seek $fileid 0 current;puts $fileid "$i : $D;"; } {   
	 incr i; } 
close $fileid 