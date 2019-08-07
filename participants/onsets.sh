#!/bin/bash
# Author: Cal Woodruff
# Purpose: this script attempts to find the onset times for phases of the experiment
#          p1 - equivalent to + in eye tracking experiment - set at NULL in triallvl.sh
#          p2 - actual start of trial (same as p1 in the case of VR and 3d)
#          p3 - set at null
#          p4 - when the subject produces an answer
#          This is used as the basis of the Onsets.pm module
# Reviewed:
# Verified:

perl -ne '
	chomp; 

	# this reads every line in each data file in the Participants_{VR,3d}/clean files 
	# it pulls out what the event is, the participant, time stamp, trial and answer
	($evt,$p,$ts,$tr,$m)=(m/(\w+),(\d+),(\d+[^,]*),[^,]*,(\d+),[^,]*,([^,]*)/); 

	# timestamps are converted to milliseconds
	if (!defined $f{$p}{$tr}) { 
		# adds in p2 onset
		$f{$p}{$tr}{first} = $ts*1000;
		$f{$p}{$tr}{p2} = $ts*1000; 

	} elsif ($evt eq "answer" and $m ne "trial start") { 
		# p4 onset when answer is selected
		$f{$p}{$tr}{p4} = $ts*1000 unless defined $f{$p}{$tr}{p3}; 
	} 

	# p4 onset is always the last event for the trial
	$f{$p}{$tr}{last} = 1000*$ts; 

	# this produces the bare bones of a module
	# that must be edited before it is used
	END { 
		use Data::Dumper; 
		$Data::Dumper::Indent = 1;
		$Data::Dumper::Sortkeys = 1; 
		print Dumper(\%f); 
	}
' "$@"

