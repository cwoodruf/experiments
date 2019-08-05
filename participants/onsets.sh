#!/bin/bash
# Author: Cal Woodruff
# Purpose: this script attempts to find the onset times for phases of the experiment
#          p1 - equivalent to + in eye tracking experiment
#          p2 - actual start of trial (same as p1 in the case of VR and 3d)
#          p3 - when the subject produces an answer
#          p4 - end of trial
#          This is used as the basis of the Onset.pm module
# Reviewed:
# Verified:

perl -ne '
	chomp; 

	# this reads every line in each data file in the Participants_{VR,3d}/clean files 
	# it pulls out what the event is, the participant, time stamp, trial and answer
	($evt,$p,$ts,$tr,$m)=(m/(\w+),(\d+),(\d+[^,]*),[^,]*,(\d+),[^,]*,([^,]*)/); 

	# timestamps are converted to milliseconds
	if (!defined $f{$p}{$tr}) { 
		# adds in p1 and p2 onsets
		@{$f{$p}{$tr}}{qw/p1 p2/} = ($ts*1000, $ts*1000) 

	} elsif ($evt eq "answer" and $m ne "trial start") { 
		# p3 onset when answer is selected
		$f{$p}{$tr}{p3} = $ts*1000 unless defined $f{$p}{$tr}{p3}; 
	} 

	# p4 onset is always the last event for the trial
	$f{$p}{$tr}{p4} = 1000*$ts 

	# this produces the bare bones of a module
	# that must be edited before it is used
	END { 
		foreach $p (sort keys %f) {
			foreach $tr (sort keys %f) {
				if ($f{$p}{$tr}{p3} == 0) {
					$f{$p}{$tr}{p3} = $f{$p}{$tr}{p4};
				}
			}
		}
		use Data::Dumper; 
		$Data::Dumper::Indent = 1;
		$Data::Dumper::Sortkeys = 1; 
		print Dumper(\%f) 
	}
' "$@"

