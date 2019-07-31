#!/bin/bash
cd ~/Desktop/Participants_3d/clean/
perl -MThreeDOnsets -pe '($p,$tr) = (m#^(\d+),(\d+)#); foreach $ph (qw/p1 p2 p3 p4/) { s/${ph}Onset/$ThreeDOnsets::times{$p}{$tr}{$ph}/ }' blocks3dTriallvl.csv > blocks3dTriallvl-with-onsets.csv 
cd ../../Participants_VR/clean/
perl -MVROnsets -pe '($p,$tr) = (m#^(\d+),(\d+)#); foreach $ph (qw/p1 p2 p3 p4/) { s/${ph}Onset/$VROnsets::times{$p}{$tr}{$ph}/ }' blocksvrTriallvl.csv > blocksvrTriallvl-with-onsets.csv
