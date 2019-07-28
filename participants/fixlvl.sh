#!/bin/sh
# grab fixation data from raw game logs
COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
export PERL5LIB="/Users/collector/Desktop/experiments/participants:$PERL5LIB"
outfile=blocks${COND}Fixlvl.csv
# echo Start,Duration,Subject,TrialID,TrialPhase,RowID > $outfile
echo Start,Duration,Subject,TrialID,TrialPhase,X,Y,Location,FuncRelevance,RowID > $outfile
grep -h '^fixation,' [23]*txt | \
perl   -MIrrelevantMap -MPOSIX -ne '
BEGIN { %loc = ("no side"=>0,up=>1,right=>2,forward=>3) }
if (m#fixation,(\d+),(\d+[^,]*),(cubeset=\d+/catmap=\d+),(\d+),(cat:[^,]*).*,(up|right|forward),#) { 
	next unless $4 > 0;
	$f{$s}{$tr}{$fix}{dur} = ceil($2*1000-$f{$s}{$tr}{$fix}{start}) unless defined $f{$s}{$tr}{$fix}{dur}; 
	($s,$ts,$cond,$tr,$cube,$o)=($1,$2,$3,$4,$5,$6); 
	$fix++; 
	$f{$s}{$tr}{$fix} = { 
		fix=>$fix, 
		start=>ceil($ts*1000), 
		trial=>$tr, 
		subject=>$s, 
		phase=>ceil($tr/60), 
		X=>0.0, Y=>0.0, Location=>$loc{$o},
		relevant=> isRelevant($cond,$cube,$o) 
	} 
} elsif (/fixation,(\d+),(\d+[^,]*),.*?,(\d+),/) { 
	next unless $1 == $s; 
	$f{$s}{$tr}{$fix}{dur} = ceil($2*1000-$f{$s}{$tr}{$fix}{start}); 
} 
END { 
	foreach $s (sort keys %f) { 
		foreach $tr (sort {$a <=> $b} keys %{$f{$s}}) { 
			foreach $fix (sort {$a <=> $b} keys %{$f{$s}{$tr}}) { 
				next unless $f{$s}{$tr}{$fix}{start} > 0;
				print join ",", @{$f{$s}{$tr}{$fix}}{
					qw/start dur subject trial phase X Y Location relevant/}; 
				print "\n" 
			} 
		} 
	} 
}' | perl -pe 's/$/,$./' >> $outfile

