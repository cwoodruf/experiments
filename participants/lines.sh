#!/bin/sh
# Author: Cal
# Purpose: older test script not used in analysis
#          grabs raw data and counts the number of lines
#          prints statistics about this

cd /Users/collector/Desktop/experiments/participants
wc -l {vr,3d}/data/*/*.txt | \
grep -v 505.txt | \
perl -ne '
	($c,$e)=(/(\d+) (\w\w)\//) or next; 
	next unless $c > 999; 
	push @{$f{$e}{median}}, $c; 
	$f{$e}{sum} += $c; 
	$f{$e}{sum2} += $c*$c; 
	$f{$e}{N}++; 
	END { 
		foreach $e (keys %f) { 
			($m, $sum,$sum2,$N) = @{$f{$e}}{qw/median sum sum2 N/}; 
			$av=$sum/$N; 
			@m = sort @$m; 
			printf "$e median %d av %.2f sd %.2f N %d\n", 
				$m[(scalar @m)/2], $av, sqrt($sum2/$N-$av*$av), $N 
		} 
	}
'
