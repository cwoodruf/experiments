#!/bin/sh
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
