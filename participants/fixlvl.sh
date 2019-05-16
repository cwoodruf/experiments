#!/bin/sh
# grab fixation data from raw game logs
COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
outfile=blocks${COND}fixlvl.csv
echo Start,Duration,Subject,TrialID,TrialPhase,RowID > $outfile
grep -h '^fixation,' [23]*txt | \
perl   -MPOSIX -ne '
if (/fixation,(\d+),(\d+[^,]*),.*?,(\d+),.*,(up|right|forward),/) { 
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}) unless defined $f{$s}{$tr}{$fix}{dur}; 
	($s,$ts,$tr,$o,$lh,$rh,$h)=($1,$2,$3,$4,$5,$6,$7); 
	$fix++; 
	$f{$s}{$tr}{$fix} = { fix=>$fix, start=>$ts*1000, trial=>$tr, subject=>$s, phase=>ceil($tr/60) } 
} elsif (/fixation,(\d+),(\d+[^,]*),.*?,(\d+),/) { 
	next unless $1 == $s; 
	$f{$s}{$tr}{$fix}{dur} = ($2*1000-$f{$s}{$tr}{$fix}{start}); 
} 
END { 
	foreach $s (sort keys %f) { 
		foreach $tr (sort {$a <=> $b} keys %{$f{$s}}) { 
			foreach $fix (sort {$a <=> $b} keys %{$f{$s}{$tr}}) { 
				print join ",", @{$f{$s}{$tr}{$fix}}{qw/start dur subject trial phase fix/}; 
				print "\n" 
			} 
		} 
	} 
}' >> $outfile

