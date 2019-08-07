#!/bin/sh
# Author: Cal Woodruff
# Purpose: builds an experiments level table for the vr and 3d experimental conditions
#          This reads the log data created by the coalesce script and pulls out data on
#          each particpant including condition and whether they met the learning criterion
# Reviewed:
# Verified:

COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
outfile=blocks${COND}Explvl.csv

# cube features are in the order of up right forward
echo Subject,CubeSet,CategoryMapping,CP,GazeExcluders,RowID > $outfile

# read every file in the directory starting with 2 or 3 and ending in .txt
for f in [23]*.txt 
do 
	# we are only interested in the lines starting with "answer"
	grep -h ^answer, $f | sort | \
	perl -ne '
	# cp is the criterion point
	BEGIN { $cp = 0 }
	chomp; 
	# remove "answer, from the start of line
	s/^answer,//; 

	# this parses a log line pulling out the subject id, start time, condition and actual and selected answer
	if (m#^(\d+),(\d+[^,]*),cubeset=(\d+)/catmap=(\d+),(\d+),cat: . cube:/(..)/(..)/(..),(.),([ABCD])#) { 

		# this checks if the answer is correct
		# if the criterion point is met we leave otherwise we return to zero
		if ($9 eq $10) {
			$cp++;
		} elsif ($cp < 24) {
			$cp = 0;
		}
		# print STDERR "subj $1: actual $9 chosen $10 cp $cp\n";
		# subj, cubeset, catmap, cp, gaze excluders
		$f{$1} = "$1,$3,$4,".($cp >= 24 ? 1: 0).",NULL";
	} 
	END { 
		# sort the list by subject
		foreach $s (sort { $a <=> $b } keys %f) { print $f{$s},"\n" } 
	}'
done | grep '^[23]0' | perl -pe 's/$/,$./' >> $outfile
# this final line adds the row number

