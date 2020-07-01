CogSci WhiteBox

Authors: Rollin Poe, Tyrus Tracey
Date: Spring 2017
Purpose: Explore options for future VR studies. Investigate unity operations, I/O, text files, movement, custom textures, etc.
====================

How to use:
*NOTE: You only need to install Unity if you wish to play the game in editor or edit/view the game in its raw state.
1. Download and install Unity (make sure your package is newer or equal to 2017.3)
2. Extract all the files from the WhiteBox_1.rar into your Unity projects folder. This should output the CogSci WhiteBox folder.
3. Launch Unity and select "CogSci WhiteBox".
4. Make sure the scene you're running is "wire2"
  4a. If the scene is blank/not on wire2, the scene can be changed from File>Open Scene>_Scenes>wire2.unity or from the project window under the _Scenes folder

Playing the game in the editor:
1. To play, simply press the "Play Button" located at the top of the editor. 
2. To exit, press "Esc" then the Play Button. You will be returned to the editor.
Controls:
  WASD or Arrow Key will allow you to move around the playspace
  Space to jump
  Left Click to pick up a game object
  Right Click will throw the object in the direction the player character is facing
  Holding "E" will lock the camera and allow you to rotate the object in 3Dspace. Release "E" to regain camera control (and lose object rotation). XYZ movement is allowed when holding "E"
  *Controller Support is not in this version of the demo*

Playing the fully built game
1. Double click and launch the WhiteBoxeDemo.exe (Windows) or WhiteBoxDemo.app (Mac) found in the "Game" top-level folder.
2. Select the correct display options for your computer/monitor. The default options will usually be okay.
3. Click "Play!"
4. To exit the game:
  4a. If you are playing in windowed mode, simply press escape, then close the window
  4b. If you are playing in fullscreen mode, you must close the window manually. This can be done from the task manager (Ctrl-Shift-Esc) (Windows) or force quit menu(Command-Option-Esc) (Mac) , or by entering task mode/mission control and closing the window with the red x


**Gameplay notes and more info found in FINAL NOTES section below.
====================

Data Output:

*** YOU WILL NOT BE ABLE TO READ/ACCESS THE OUTPUT.CSV IF YOU ARE PLAYING FROM THE .EXE ***
*** THIS VERSION WILL ONLY OUTPUT PLAY DATA IF YOU RUN THE GAME IN THE EDITOR ***

The "Output.csv" can be found in \Unity\CogSci WhiteBox\Assets\Resources
The CSV will data from the player, camera, and objects.
  Time (Elapsed since first play in seconds)
  Player position in X,Y,Z (Y is vertical jump)
  Camera Angle X,Y
  Object to be categorized
  Whether the object is held or not
  Object Postion in X,Y,Z (Spawnpoint at (0,3,0) )
  Object Rotation X,Y,Z
    Angles are relative to room global when not being held (0,0,0 = no rotation, same as spawn)
    Angles are relative to player camera when being held 
      *I'm pretty sure about this. More testing and a better system in future
  Whether the player categorizes the object correctly (0 = no categorization, 1 = correct, -1 = incorrect)
  Whether the object is visible to the player
  Whether the object is centered in the players view

What's in the folders?
  The only folder with properties you should care about is the Assets folder
    _Scenes: can be thought of as levels. Only wire2 is fully featured. wireframe.unity was an early test
    Materials: Contains textures for all objects in game
    Prefabs: Contains templates for game objects. Only CBox is currently being used
    Resources: Contains sound effects. Where output.csv will be saved to
    Scripts: Old scripts from wireframe.unity. I don't believe any are in use in wire2.unity
    Scripts2: Contains scripts used to make game objects interact and behave how I wanted them.
    Standard Assets: Unity Standard assets. Contains everything needed for basic characters/controls. Wire2 uses FirstPersonCharater
    Textures: Contains image files for custom box textures used on CBox prefab

What do the scripts do?
***NOTE: these scripts are ugly, messy, optimized and probably poorly commented. These were learning experiences for Unity and C#****
  
  BlueCubeTriggerBehave (Also RedCube, RedSphere, BlueSphere): Detect if object has entered trigger zone. Make judgement on correctness. Spawn new object for player.
  BoxCorpRotate: Rotate the BoxCorp boxes in X,Y,Z with IJKLUO keys.
  camStats: Display player position in X,Y,Z and camera angle X,Y in real time in game
  Counter: Count number of correct/incorrect from *TriggerBehave. At 10 correct, display total right/wrong and "end" game.
  inCamFrustum: Detect if object is visible by player.
  inView: Detect if player is looking at object. Defined as if reticule is over game object.
  NewObjectControl: Allows objects to be picked up, moved, thrown, and rotated. Display reticule.
  Printer: Collect data and print to output.csv
    NOTE: Printer will continue to add to the csv regardless of if you stop and restart the game. Each new game will be added to be bottom of the csv. You can manually delete the csv to get a clean record.
  TriggerBehaviour: Old trigger script. Not in use.
  

####################
FINAL NOTES:

Gameplay:
  If you enter the triggers for the objects the game will hardlock and you will be unable to continue.
  If you throw an object out of bounds and off the edge, the game will softlock (kinda). 
  If you yourself fall off the edge the game will continue, but you won't be able to do anything.
  If you throw one of the objects that exist outside the playspace walls into a trigger, that object will no longer spawn and you will eventually softlock the game
  If you are experiencing framerate drop in the unity editor version, consider playing the fully built game, which is better optimized
Technical:
* This game is messy, buggy, poorly optimized, has legacy features, scripts all over the place, is bodged together and held up by sticks, glue, and hope, but was and is a great learning experience.
* Very few, if any, of the assets here should be brought over to the actual experiment. We can port ideas and concepts, but copy paste is probably not going to work.
* Neither controllers nor VR are supported in this version of the game. Newer projects have looked into this and may be uploaded to SFU Vault in future.

* Future ideas for next version need discussion with development team including:
  -Design specs/idea for actual experiment
  -What is needed for printer
  -Rotation and object identification clean up
  -Control scheme
  -Art assets
  -Software engineering/architecture problems and solutions
  -More to be added
