#!/bin/sh
COND=$1
if [ "x$COND" = "x" ]
then
	echo "need a condition - either vr or 3d"
	exit 1
fi
outfile=blocks${COND}Explvl.csv

# cube features are in the order of up right forward
echo Subject,CubeSet,CategoryMapping,CP,GazeExcluders,RowID > $outfile

for f in [23]*.txt 
do 
	grep -h ^answer, $f | sort | \
	perl -ne '
	BEGIN { $cp = 0 }
	chomp; 
	s/^answer,//; 
	if (m#^(\d+),(\d+[^,]*),cubeset=(\d+)/catmap=(\d+),(\d+),cat: . cube:/(..)/(..)/(..),(.),([ABCD])#) { 
		if ($9 eq $10) {
			$cp++;
		} elsif ($cp < 24) {
			$cp = 0;
		}
		# print STDERR "subj $1: actual $9 chosen $10 cp $cp\n";
		$f{$1} = "$1,$3,$4,".($cp >= 24 ? 1: 0).",NULL";
	} 
	END { 
		foreach $t (sort { $a <=> $b } keys %f) { print $f{$t},"\n" } 
	}'
done | grep '^[23]0' | perl -pe 's/$/,$./' >> $outfile

