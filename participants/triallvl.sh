#!/bin/sh
cd /Users/collector/Desktop/Participants_VR/clean
# cube features are in the order of up right forward
outfile=blocksvrtriallvl.csv

echo Subject,TrialID,Cubeset,Catmap,UpValue,RightValue,ForwardValue,StartTime,AnswerTime,RowID > $outfile

for f in 2*.txt 
do 
	grep -h ^answer, $f | sort | \
	perl -ne '
	chomp; 
	s/^answer,//; 
	if (m#^(\d+),(\d+[^,]*),cubeset=(\d+)/catmap=(\d+),(\d+),cat: . cube:/(..)/(..)/(..),(.),(trial start|[ABCD])#) { 
		undef $ts if $prev != $5;
		if ($10 eq "trial start") {
			$ts = $2;
			$f{$5} =~ s/,,/,$ts,/;
		} elsif ($ts <= $2) {
			$f{$5} = "$1,$5,$3,$4,$6,$7,$8,$10,$9,$ts,$2";
		}
		$prev = $5;
	} 
	END { 
		foreach $t (sort { $a <=> $b } keys %f) { print $f{$t},"\n" if $t > 0 } 
	}'
done | grep '^20' | perl -pe 's/$/,$./' >> blocksvrtriallvl.csv

