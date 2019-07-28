#!/usr/bin/perl
# purpose of this script is to use phase starts per trial from a fixation table
# and interpolate them into a trial table

# get file names
my $fixtbf = shift;
my $trialtbf = shift;
open FIX, "< $fixtbf" or die "$fixtbf: $!";
my %phases;
while (my $_ = <FIX>) {
	if (/^(\d+),(\d+),(\d+),(\d+),(\d+)/) {
		($st, $dur, $subj, $tr, $ph) = ($1,$2,$3,$4,$5);
		$phases{$subj}{$tr}{"p".($ph-1)."Onset"} = $st;
	}
}
use Data::Dumper; $Data::Dumper::Sortkeys = 1; print Dumper(\%phases);

