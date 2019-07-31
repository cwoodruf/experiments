#!/bin/bash
# grab fixation data from raw game logs
export COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
export PERL5LIB="/Users/collector/Desktop/experiments/participants:/Users/collector/Desktop/Participants_3d/clean:/Users/collector/Desktop/Participants_VR/clean:$PERL5LIB"
outfile=blocks${COND}Fixlvl.csv
# echo Start,Duration,Subject,TrialID,TrialPhase,RowID > $outfile
echo Start,Duration,Subject,TrialID,TrialPhase,X,Y,Location,FuncRelevance,RowID > $outfile
grep -h '^fixation,' [23]*txt | \
perl   -MOnsets -MIrrelevantMap -MPOSIX -ne '
sub getphase {
	my ($p,$tr,$ts) = @_;
	die "missing phase info for $p $tr!" unless defined $times{$ENV{COND}}{$p}{$tr};
	my $pcount = 1;
	foreach my $ph (sort values %{$times{$ENV{COND}}{$p}{$tr}}) {
		if ($ts <= $ph) {
			return $pcount;
		}
		$pcount++;
	}
}
	
BEGIN { 
	%loc = ("no side"=>0,up=>1,right=>2,forward=>3) 
}
if (m#fixation,(\d+),(\d+[^,]*),(cubeset=\d+/catmap=\d+),(\d+),(cat:[^,]*).*,(up|right|forward),#) { 
	next unless $4 > 0;
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}) unless defined $f{$s}{$tr}{$fix}{dur}; 
	($s,$ts,$cond,$tr,$cube,$o)=($1,$2,$3,$4,$5,$6); 
	$fix = $ts; 
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
	next unless $1 == $s; 
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}); 
} 
END { 
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

