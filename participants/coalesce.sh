#!/bin/sh
# Author: Cal Woodruff
# Purpose: reads data from the on host logs and the experiments manager REST logs and 
#          coalesces the data into an ordered csv log for each participant
#          currently this data is in the ~/collector/Desktop/Participant_{VR|3d}/clean/ directories
# Reviewed:
# Verified:

COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either 3d or vr"
	exit 1
fi
grep -h ',[23]0[0-9][0-9][0-9],' ../data/*csv ../../experiments/participants/${COND}/data/142.58.*/*-[0-9]*.txt | \
perl -ne '
if (/\w+,(\d+),(\d+[^,]*),[^,]*,(\d+)/) { 
	$ord{$1}{$3}{$2} = $_; 
} 
END { 
	foreach $s (sort keys %ord) { 
		foreach $t (sort {$a <=> $b } keys %{$ord{$s}}) { 
			foreach $ts (sort { $a <=> $b } keys %{$ord{$s}{$t}}) { 
				if ($s != $ps) { 
					print "saving $s.txt\n";
					open OUT, ">$s.txt" or die $!; 
					$ps = $s 
				} 
				print OUT $ord{$s}{$t}{$ts} 
			} 
		} 
	} 
}'
