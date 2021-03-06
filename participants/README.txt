About data processing.

There are 3 scripts that map to the standard tables:

 * explvl.sh - builds csv for the experiments table
 * triallvl.sh - builds csv for the trial table
 * fixlvl.sh - builds the csv for the fixations table

The trial and fix scripts require an Onsets.pm module.
This is created with the onsets.sh script:

 onsets.sh 20*.txt >> ../../experiments/participants/OnsetsNew.pm
 onsets.sh 30*.txt >> ../../experiments/participants/OnsetsNew.pm

The resulting module is edited and copied to Onsets.pm in the same
directory as the *lvl.sh scripts. 

The onsets.sh scripts produces data structures named $VAR1. Change
these to $onsets{vr} for the vr data and $onsets{3d} for the 3d data.

The structure of the result is thus

  package Onsets;
  our %onsets;
  $onsets{vr} = {
     '20NNN' => {
  ...
      },
  ...
    }
  };
  
  $onsets{'3d'} = {
      '30NNN' => {
  ...
      },
  ...
    }
  };
  
  1;


The *lvl.sh are then run in the directory with the data:

 cd ../../Participants_VR/clean
 ../../experiments/participants/fixlvl.sh vr

The scripts produce the following files:

 * explvl.sh : outfile=blocks${COND}Explvl.csv
 * fixlvl.sh : outfile=blocks${COND}Fixlvl.csv
 * triallvl.sh : outfile=blocks${COND}Triallvl.csv

Where $COND can be either "vr" or "3d".


