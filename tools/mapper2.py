#!/usr/bin/env python
"""
Goal for this script is to reduce the complexity of mapper.py possibly by using recursion 
where I'm walking through relatively small arrays with for/while loops.
Notably the "permutations" function is hiding this to some extent but some of the loops
where I am going through layered loops where I am trying to change the first elements
less quickly than the later elements.
"""
import json, sys, os, numpy
import argparse
import logging
from itertools import permutations, product

class StimuliGroups(object):

    def __init__(self, colorshapes):
        """
        reads in a dict of dimensions/axes (colors) and states for those dimensions (shapes)
        most of the object members are for tracking processing except arrangements
        which are what this class builds
        """
        self.colorshapes = colorshapes

    def _valuepermutations(self):
        """
        expands the given map of colorshapes to provide 
        permutations of the shape values for each color axis
        """
        valuepermutations = {}
        # in a typical experiment an axis might be represented by a color
        # and the values might be represented by shapes
        for axis, values in self.colorshapes.iteritems():
            # push the axis value down for later reference when producing output
            valuetuple = [(axis, v) for v in values]
            valuepermutations[axis] = []
            # we are gathering permutations of the axis values as they can map uniquely to categories
            for valueperm in permutations(valuetuple):
                valuepermutations[axis].append(valueperm)

        return valuepermutations

    def build(self):
        """
        Takes the map of dimensions/axes (colors) and states (shapes)
        and for each permutation of the list of shapes per color, builds
        a set of stimuli mapped to categories rotated through each possible
        position of the dimensions

        Side effect: creates self.stimuligroups data structure
        """
        # in an experiment these are visual stimuli that are typically arranged around a central point
        wedgesize = 360 / len(self.colorshapes)
        orientations = [wedgesize * a for a in xrange(len(self.colorshapes))]

        # used below when determining the category of a given stimuli
        # because we use distracters categories can map to more than one unique stimulus
        valuetuple_product = numpy.product([len(values) for values in self.colorshapes.values()])

        self.stimuligroups = {}

        valuepermutationlists = self._valuepermutations().values()
        valuetuplecount = 0

        # its arguable that a better approach may be to iterate through permutations
        # of categories for each set of values and that this will cover every possible
        # mapping of axis/color group to category - however this recreates the behavior
        # of the original mapper script

        for valuetuples in product(*valuepermutationlists):
            # only use one permutation of the last distracter axis
            valuetuplecount += 1
            if valuetuplecount % len(valuetuples[-1]) != 0:
                continue

            # we are building lists of lists of cubes
            # each list covers every possible cube/category mapping
            # the lists are determined by the orientation of the axes

            for cubesetcount, angles in enumerate(permutations(orientations)):

                categorymaps = []
                for vts in permutations(valuetuples):

                    # make into a list for product below
                    valuelists = [list(valuetuple) for valuetuple in vts]

                    # the last element in the valuetuples permutation is a distracter stimulus
                    numcats = valuetuple_product / len(valuelists[-1])
                    cattuple = [cat for cat in xrange(numcats)]
                    categorymap = []
                    for i, valuelist in enumerate(product(*valuelists)):
                        cat = cattuple[i / (valuetuple_product/numcats)]

                        # using only one map in an array of arrays seems to work better with various json parsers
                        # {"color": "r", "shape": "O", "rotation": 240, "cat": "c3"}
                        stimulus = [{
                            "color": valuelist[j][0], 
                            "shape": valuelist[j][1], 
                            "rotation": angles[j], 
                            "cat": "c{0}".format(cat)} for j in xrange(len(valuelists))]

                        # print stimulus
                        categorymap.append(stimulus)
                    if cubesetcount not in self.stimuligroups:
                        self.stimuligroups[cubesetcount] = []
                    self.stimuligroups[cubesetcount].append(categorymap)

def readcolorshapes(inputfile):
    with open(inputfile, "r") as sh:
        try:
            colorshapes = json.load(sh)
        except Exception as e:
            logging.error("failed to read json data - please check the format")
            return 
        return colorshapes

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("-d","--debug", help="print debug output", action="store_true")
    parser.add_argument("-v","--verbose", help="print full json string of output", action="store_true")
    parser.add_argument("inputfile", 
    help="json object mapping colors to shapes "
        "should be in form of { \"color 1\":[\"shape 1\",...],...}")
    args = parser.parse_args()
    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.ERROR)

    builder = StimuliGroups(readcolorshapes(args.inputfile))
    builder.build()

    if args.verbose:
        print json.dumps(builder.stimuligroups)
    else:
        print "stimuli groups", len(builder.stimuligroups)
        for i, group in builder.stimuligroups.iteritems():
            print "group %d has length %d" % (i, len(group))
            prevlen = -1
            for s, stimulus in enumerate(group):
                if prevlen > 0 and prevlen != len(stimulus):
                    print "stimulus has different length", len(stimulus), stimulus
                prevlen = len(stimulus)


