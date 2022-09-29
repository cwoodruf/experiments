# Experiments Manager Tools

These scripts are tools for managing experimental conditions. 

* mapper2.py/mapper.py - this uses a JSON input file to create a comprehensive list of 
  experimental conditions for category learning experiments. 
  See "arrangements" REST call in manager.py

* irrelevant.py - takes the JSON output by mapper.py and identifies irrelevant
  features - in this case specifically for the 3x2 VR experiment

* mappertest.py - command line tool to exercise the mapper.py script

* conditions.py - command line tool to generate a list of evenly distributed
  conditions for the VR experiment.

