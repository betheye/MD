puts "Input the structure your want to calculate in VMD format (without 'atomselect top'): 
for example : protein and chain A or protein and chain B and resid 123 "  
flush stdout
set sel_vmd [gets stdin] 
puts "How offen do you want to calculate the SASA (frames between two calculations) ?
(default is 1, calculate SASA for each frames)" 
flush stdout
set c [gets stdin]
puts "How large probe radius would you like to use ?
(default is 1.4 A) "
flush stdout
set p [gets stdin]
puts "How high resolution do you would like to apply for the calculation ?
(default is 100)"
flush stdout
set n [gets stdin]
if { $c == "" } { set c 1 }
if { $p == "" } { set p 1.4 }
if { $n == "" } { set n 100 }
set outfile [ open vmd_SASA_$sel_vmd.dat w ]
set nf [ molinfo top get numframes ]
set sss 1
for { set i 1 } { $i < $nf } { incr $sss } {
set temp_sasa [ measure sasa $p [ atomselect top "$sel_vmd" frame $i ] -samples $n ]
puts $outfile "$temp_sasa"
set i [ expr $i + $c ]
}
close $outfile
puts "All Done !"