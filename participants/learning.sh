#!/bin/sh

for f in $(wc -l {vr,3d}/data/*/*.txt | grep -v 505.txt | perl -ne '($c,$e)=(/(\d+) (\w\w\/.*)/) or next; next unless $c > 999; print $e,"\n"')
do 
	echo FILE $f
	./scan.pl $f
	echo
done > summaries.txt

perl -ne '
BEGIN { $T = 24 } 
if (/FILE (.*)/) { $f=$1; $rights=0 } 
else { 
	($t,$a)=(/trial\s+(\d+)\s+(wrong|right)/) or next; 
	if ($rights < $T) { 
		$rights += ($a eq "right") ? 1 : -$rights; 
		print "$T right starting at ",($t-$T)," for $f\n" if $rights >= $T 
	} 
}' summaries.txt | tee learning.txt

