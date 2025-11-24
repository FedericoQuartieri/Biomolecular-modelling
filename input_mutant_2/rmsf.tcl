set outfile [open rmsf.dat w]
set ca [atomselect top "name CA"]
set numca [$ca num]
set rmsf [measure rmsf $ca]
for {set i 0} {$i < $numca} {incr i} {
	puts $outfile "[expr {$i+1}] [lindex $rmsf $i]"
}
close $outfile

