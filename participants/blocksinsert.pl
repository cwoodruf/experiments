#!/usr/bin/perl
# purpose of this script is to insert blocks data from 2019 Spring into various tables in the Experiments db
use DB::Experiments;
use strict;
my $db = DB::Experiments::conn();
my $basedir = "/Users/collector/Desktop";
my %file2tb = (
	"Participants_VR/clean/blocksvrExplvl.csv" => "vrTestExpLvlVR",
	"Participants_VR/clean/blocksvrTriallvl-with-onsets.csv" => "vrTestTrialLvlVR",
	"Participants_VR/clean/blocksvrFixlvl.csv" => "vrTestFixLvlVR",
	"Participants_3d/clean/blocks3dExplvl.csv" => "vrTestExpLvl3d",
	"Participants_3d/clean/blocks3dTriallvl-with-onsets.csv" => "vrTestTrialLvl3d",
	"Participants_3d/clean/blocks3dFixlvl.csv" => "vrTestFixLvl3d",
);

foreach my $fn (sort keys %file2tb) {
	open IN, "$basedir/$fn" or die "$basedir/$fn: $!";
	my $header = <IN>;
	chomp $header;
	my @fields = split ",", $header;
	my $tb = $file2tb{$fn};
	my $query = "replace into $tb (".(join ",", @fields).") values (".(join ",", map { "?" } @fields).")";
	print "$query\n";
	my $ins = $db->prepare($query);
	while (my $l = <IN>) {
		chomp $l;
		my @data = split ",", $l;
		for (my $d=0; $d<scalar @data; $d++) {
			$data[$d] = undef if $data[$d] eq "NULL";
		}
		print "@data\n";
		$ins->execute(@data) or die $ins->errstr;
	}
}
$db->disconnect();
	
