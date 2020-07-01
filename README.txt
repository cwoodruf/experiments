VR system set up
================

Open two cygwin windows:
1) on one window:
cd Desktop
tail -f df.csv

2) on the second window:
ssh collector
(you'll now be on mary as the collector user if successful)
cd Desktop/experiments
./restart.sh
tail -f manager.log
(look for errors here)

When starting the VR system you may need to do a quick calibration.
This may be a good idea to do before the first participant.

To do this, open the Steam VR application. In the upper left corner
of the small window click on Settings > Developer
Scroll down until you see the "Quick Calibrate" button.
Put the VR Head Set on the floor facing the direction where "front"
should be. Click the "Quick Calibrate" button. "Front" should now
face in the direction of the headset. It may take a couple of tries
before this works.

When starting the experiment make sure that the C:\ drive version of
the VR_Fall2018_1 project is loaded. In this project the 
SetParticipantCondition scene should be loaded to start a run of the
experiment. 

Before starting, measure the participants interpupil distance with the
card that comes with the VR headset or with a millimeter ruler.
Use the small knob at the right lower corner of the head set to
adjust the width of the lenses to match this distance in the VR system. 

Have the participant read the into blurb on the screen. While they do this
set the participant id, and the cube set/category map counterbalancing
conditions. In most cases, filling these in automatically with the
"New Participant" button will be good enough. 

Note the participant id, and the counterbalancing condition so we can 
ensure that these settings are used in each variant of the experiment.

With the participant id, cube set and category map set, click 
"Use These Settings" to start the experiment. Make sure both 
hand controllers are turned on and visible to the participant 
before starting. Have them click the arrow to bring up a cube. 
The VR system will automatically detect which hand is holding each
controller.

A run of the experiment is considered finished after:

 3 correct categorizations in a row
 50 minutes
 350 trials

whichever comes first. 

Use the output of tail -f df.csv to track the number of trials.

Problems?

If the collector window starts showing errors it may be necessary
to restart the experiments manager application with ./reset.sh.
If problems persist let us know. In general, these issues can be
fixed remotely.

If neither the local log file or collector is collecting data
the run must stop and the technical issues must be fixed.

For problems with the VR system, rebooting the VR system with the 
SteamVR application may be necessary. Put the VR headset on the floor
facing the far wall before doing this.

Both manual VR controllers must be available to run the experiment.
Make sure they are sufficiently charged before running participants.

We have two headsets and 4 hand controllers.

