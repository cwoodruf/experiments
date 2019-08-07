#!/usr/bin/perl -n 
# Author: Cal
# Purpose: test script not used in the analysis to look at raw participant data

# run the script like this:
# ./scan.pl [data file]
if ($started and !defined $right and /^fixation/) { 
	if (/fixation,\d+,(\d+[^,]*),.*?,(\d+),.*,(up|forward|right|no side),/) { 
		($t,$c,$s)=($1,$2,$3); 
		$f{$s}++ if $s ne "no side";

		# ms is the number of milliseconds for the fixation
		# the fixations are all pairs of (up|forward|right) and no side 
		$ms += ($t-$p)*1000 if $s eq "no side" and (($t-$p) >= 0) and $p > 0;

		# remember the previous timestamp 
		$p=$t;
 
		# remember the previous actual side 
		$ps=$s if $s ne "no side";  

		# if the previous side seen is not the same as previous previous side seen 
		# we are now looking at a different side
		# ie: up, ns, up, ns, up, ns, forward
		$N++ and $cum+=$ms and $c2+=$ms*$ms and $ms=0 if $pps ne $ps;
 
		# remember the previous previous actual side we saw
		$pps = $ps;
	} 
} elsif ($started and /^answer,\d+,(\d+[^,]*).*,([ABCD]),([ABCD])$/) { 
	$t = $1;
	$right = (($2 eq $3) ? "right":"wrong"); 

	# get the final timing point before answering if we were looking at a side
	if ($s ne "no side") {
		$ms += ($t-$p)*1000 if (($t-$p) >= 0);
		$p = $t;
		$N++; 
		$cum+=$ms; 
		$c2+=$ms*$ms; 
		$ms=0;
	}

} elsif (/^answer,\d+,(\d+[^,]*).*trial start/) { 
	$started = 1;
	$pps = $ps = $s = undef;

	if ($N == 1) {
		$cum = $ms;
		$c2 = $ms*$ms;
	}
	printf "trial %3d $right %20s ",$c,(join "/", sort keys %f); 
	printf "av %6.2f ms SD %6.2f ms N=%d ", $cum/$N, sqrt(($c2 - $cum*$cum/$N)/$N), $N if $N > 0; 
	print "\n"; 
	%f=(); 
	$c2=$cum=$N=0;
	$right = undef;
}

