#!/bin/bash
# Author: Cal Woodruff
# Purpose: this script adds in the onset times for the vrtesttriallvl tables
# Reviewed:
# Verified:

cd ~/Desktop/Participants_3d/clean/
perl -MOnsets -pe '
	# first get the participant and trial
	($p,$tr) = (m#^(\d+),(\d+)#); 

	# then use the onsets recorded in the Onsets.pm module to fill in pNOnsets fields
	foreach $ph (qw/p1 p2 p3 p4/) { 
		s/${ph}Onset/$Onsets::times{3d}{$p}{$tr}{$ph}/ 
	}
' blocks3dTriallvl.csv > blocks3dTriallvl-with-onsets.csv 

cd ../../Participants_VR/clean/
perl -MOnsets -pe '
	($p,$tr) = (m#^(\d+),(\d+)#); 
	foreach $ph (qw/p1 p2 p3 p4/) { 
		s/${ph}Onset/$Onsets::times{vr}{$p}{$tr}{$ph}/ 
	}
' blocksvrTriallvl.csv > blocksvrTriallvl-with-onsets.csv
