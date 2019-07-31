#!/bin/bash
perl -ne '
	chomp; 
	($evt,$p,$ts,$tr,$m)=(m/(\w+),(\d+),(\d+[^,]*),[^,]*,(\d+),[^,]*,([^,]*)/); 
	if (!defined $f{$p}{$tr}) { 
		@{$f{$p}{$tr}}{qw/p1 p2/} = ($ts*1000, $ts*1000) 
	} elsif ($evt eq "answer" and $m ne "trial start") { 
		$f{$p}{$tr}{p3} = $ts*1000 unless defined $f{$p}{$tr}{p3}; 
	} else { 
		$f{$p}{$tr}{p4} = 1000*$ts 
	} END { 
		use Data::Dumper; 
		$Data::Dumper::Indent = 1;
		$Data::Dumper::Sortkeys = 1; 
		print Dumper(\%f) 
	}
' "$@"

