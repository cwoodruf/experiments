#!/bin/sh
# Author: Cal Woodruff
# Purpose: creates the triallvl table by reading the subject data and extracting answers
#          onset data is 
COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
outfile=blocks${COND}Triallvl.csv

# cube features are in the order of up right forward
# header line
echo Subject,TrialID,Feature1Value,Feature2Value,Feature3Value,Category,Response,TrialAccuracy,p1Onset,p2Onset,p3Onset,p4Onset,BadGaze,RowID > $outfile

for f in [23]*.txt 
do 
	grep -h ^answer, $f | sort | \
	perl -ne '
	chomp; 
	s/^answer,//; 
	# pull participant, time stamp, conditon, cube features and answer
	if (m#^(\d+),(\d+[^,]*),cubeset=(\d+)/catmap=(\d+),(\d+),cat: . cube:/(..)/(..)/(..),(.),([ABCD])#) { 

		($up,$right,$forward) = ($6,$7,$8);

		# this analyses the cube:/... features
		foreach $cs ($up,$right,$forward) {
			# get color and shape from strings like g=, rO etc.
			($col,$sh)=split undef, $cs;

			# print STDERR "col $col, sh $sh cval $cval{$col} fval $fval{$cs}\n";

			# my attempt at translating these into numbers to match the matlab data format
			if (defined $cval{$col}) {
				$fval{$cs} = 1 unless defined $fval{$cs};
			} else {
				$cval{$col} = 1;
				$fval{$cs} = 0;
			}
			# print STDERR "now fval{cs} $cs -> $fval{$cs}, cval{$col} $cval{$col}\n";
		}

		# this builds the actual csv line of data to match the header line above
		# note the placeholders for the onsets - these are filled in later with the onsets.sh script
		$f{$5} = "$1,$5,$fval{$6},$fval{$7},$fval{$8},$9,$10,".($9 eq $10?1:0).",p1Onset,p2Onset,p3Onset,p4Onset,NULL";
	} 
	END { 
		foreach $t (sort { $a <=> $b } keys %f) { print $f{$t},"\n" if $t > 0 } 
	}'
done | grep '^[23]0' | perl -pe 's/$/,$./' >> $outfile

