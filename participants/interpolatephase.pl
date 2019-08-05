#!/usr/bin/perl
# Author: Cal Woodruff
#
# purpose of this script is to use phase starts per trial from a fixation table
# and interpolate them into a trial table, this was a test script not used in the 
# analysis
#
# Reviewed:
# Verified:

# This uses the fixation csv output file instead of the raw data
my $fixtbf = shift;

open FIX, "< $fixtbf" or die "$fixtbf: $!";
my %phases;
while (my $_ = <FIX>) {
	if (/^(\d+),(\d+),(\d+),(\d+),(\d+)/) {
		($st, $dur, $subj, $tr, $ph) = ($1,$2,$3,$4,$5);
		$phases{$subj}{$tr}{"p".($ph-1)."Onset"} = $st;
	}
}

# outputs phase data
use Data::Dumper; $Data::Dumper::Sortkeys = 1; print Dumper(\%phases);

