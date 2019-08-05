#!/bin/bash
# Author: Cal Woodruff
# Purpose:
# grab fixation data from raw game logs

export COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
export PERL5LIB="/Users/collector/Desktop/experiments/participants:/Users/collector/Desktop/Participants_3d/clean:/Users/collector/Desktop/Participants_VR/clean:$PERL5LIB"

outfile=blocks${COND}Fixlvl.csv

# header row
echo Start,Duration,Subject,TrialID,TrialPhase,X,Y,Location,FuncRelevance,RowID > $outfile

# we grab the fixation data for every participant all at once
grep -h '^fixation,' [23]*txt | \
perl   -MOnsets -MIrrelevantMap -MPOSIX -ne '

# this function uses previously recorded Onsets information to determine the phase
sub getphase {
	my ($p,$tr,$ts) = @_;
	die "missing phase info for $p $tr!" unless defined $times{$ENV{COND}}{$p}{$tr};
	my $pcount = 1;
	# find largest phase for the time stamp
	foreach my $ph (sort values %{$times{$ENV{COND}}{$p}{$tr}}) {
		if ($ts <= $ph) {
			return $pcount;
		}
		$pcount++;
	}
}
	
BEGIN { 
	# map sides to numeric values
	%loc = ("no side"=>0,up=>1,right=>2,forward=>3) 
}

# we only consider lines starting "fixation"
# we get the subject id, condition, trial, cube and side
# this ignores "no side" - we may want to revisit this
if (m#fixation,(\d+),(\d+[^,]*),(cubeset=\d+/catmap=\d+),(\d+),(cat:[^,]*).*,(up|right|forward),#) { 
	# ignore trial 0 which is before the start of the experiment
	next unless $4 > 0;

	# calculate the fixation duration if we have not already recorded it 
	# (ie. the "no side" fixation is missing)
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}) unless defined $f{$s}{$tr}{$fix}{dur}; 

	# fill variables with collected information
	($s,$ts,$cond,$tr,$cube,$o)=($1,$2,$3,$4,$5,$6); 

	# the fixations simply have to be in order
	$fix = $ts; 

	# fill in the fixation record
	$f{$s}{$tr}{$fix} = { 
		fix=>$fix, 
		start=>($ts*1000.0), 
		trial=>$tr, 
		subject=>$s, 
		phase=>&getphase($s, $tr, $ts*1000.0), 
		X=>0.0, Y=>0.0, Location=>$loc{$o},
		relevant=> isRelevant($cond,$cube,$o) 
	} 

} elsif (/fixation,(\d+),(\d+[^,]*),.*?,(\d+),/) { 

	# in we have "no side" for this subject then calculate the duration 
	# we assume this will be after the original fixation
	# the fixations are always ordered by one with a side and one with "no side" 
	# "no side" indicates the fixation is over
	next unless $1 == $s; 
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}); 
} 
END { 
	# builds an ordered list of fixation records based on subject, trial and fixation
	foreach $s (sort keys %f) { 
		foreach $tr (sort {$a <=> $b} keys %{$f{$s}}) { 
			foreach $fix (sort {$a <=> $b} keys %{$f{$s}{$tr}}) { 
				next unless $f{$s}{$tr}{$fix}{start} > 0;
				next unless $f{$s}{$tr}{$fix}{dur} > 0;
				print join ",", @{$f{$s}{$tr}{$fix}}{
					qw/start dur subject trial phase X Y Location relevant/}; 
				print "\n" 
			} 
		} 
	} 
}' | perl -pe 's/$/,$./' >> $outfile
# last line adds the rowid for each row
