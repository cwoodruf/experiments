# Unity tools 

These tools interface with the experiments manager through DataFarmer to exercise the REST api
defined in manager.py. The main interface point is the *DataFarmer* class which, based on 
the settings in its config file, attempts to connect to an external experiments server which
it then uses to get the experimental conditions for the experiment it is running. 

The *FindClosestSide* class is an example of how to identify a fixation for a stimulus with sides.
In the case of the VR experiment the actual features were presented in wells in the sides of the
cube making the participant turn the cube more to find the feature. The features in this experiment
were identical on both sides of each axis hence the "flattening" of the angle measure.

This class uses an instance of a *DataFarmerObject* to save data via DataFarmer. DataFarmer 
keeps a list of these objects and tries to simultaneously save them locally and remotely.
The computational cost of this operation requires that it be done in a separate thread. 

* DataFarmer.cs - class that manages saving data locally and remotely

* IDataFarmerObject.cs, DataFarmerObject.cs - root class/interface for data items to be saved

* DFAnswerSelection.cs - instance of DataFarmerObject that keeps the category chosen by the
  participant

* DFFixation.cs - instance of DataFarmerObject that keeps a fixation on a feature

* FindClosestSide.cs - class that creates DFFixation objects when the feature being looked at changes

* ParticipantStatus.cs - class that works with DataFarmer to manage the state of the experiment

* CubeArrangements.cs - used by DataFarmer to hold the experimental conditions

* Cubes.cs - a list of cubes. Generically a "cube" is a group of 3 features that map to a category. 
  The Cubes class holds all the cube objects for a given experimental conditon.

* CubeTuple.cs - represents the features of a given cube.

