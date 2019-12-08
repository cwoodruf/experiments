#!/usr/bin/env python
"""
This tool takes as input 
- a list of groups of shapes + colors in the form of {"color": ["shape",...],...}

It outputs an exhaustive inventory of categories and their related groups of symbols.
One group of category shape mappings represents an experimental condition.

The mapping of a given shape and color is assumed to be static. Although shapes
could be repeated for colors.

The "shapes" are symbols. These are combined in multiple dimensions. 

One dimension is the location of the shape in a display. This is represented as a unique 
angle in a cirle. For any given input there are a fixed number of positions that a shape 
can be found in. For 3 for example 0 is top, 120 is right and 240 is left (for the viewer). 

A second dimension is how the shape maps to a category. This is represented by an ordinal
position for a given group of shapes represented by a color. In the first position the 
shape is changed the least frequently, only when all the other shapes for a color have cycled 
through their permutations. In the second position the color's shape is changed only when
the next position's shapes have been cycled through and so on. In the last position is a color
where every shape always maps to any given category. This color is called "irrelevant" because it 
does not give any useful information for determining the category based on the color.
It is possible to have multiple irrelevant features.

An easier way to visualize this category mapping for 3 colors with 2 shapes is by using 
binary numbers. The following represents one arrangement or mapping of categories to the
colors r, b and g with shapes 0 and 1 respectively:

   r  b  g
c1 0  0  0
c1 0  0  1
c2 0  1  0
c2 0  1  1
c3 1  0  0
c3 1  0  1
c4 1  1  0
c4 1  1  1

We can see that, for this arrangement, r0,b0 "means" c1 and that r0,b1 "means" c2 and so on.

Recall that this enumeration does not take into account where the shapes are shown in
the display. There would be 6 arrangements of each of these groups where r, b and g would
rotate through being in the top, left and right positions:
 
1.  r     2.  r     3.  g     4.  g     5.  b     6.  b
  b   g     g   b     r   b     b   r     g   r     r   g

The number of positions and the number of columns directly relate to each group of shapes.
The number of categories depends on the number of combinations of relevant color groups. 
The number of conditions relating to a category relates to the size of the groups.
We expect groups to always be the same size.

It is assumed that the largest ordinality (at least) is always an irrelevant feature
i.e. it will be represented equally in each category.
The relevant features must uniquely map to each category. The irrelevant
feature should never map to a specific sub-group of categories.

"""
import json, sys, os, numpy
import argparse
import logging
from itertools import permutations, product

class StimuliGroups(object):

    def load(self, inputfile):
        """
        reads in a dict of dimensions/axes (colors) and states for those dimensions (shapes)
        most of the object members are for tracking processing except arrangements
        which are what this class builds
        """
        with open(inputfile, "r") as sh:
            try:
                self.colorshapes = json.load(sh)
            except Exception as e:
                logging.error("failed to read json data - please check the format")

        return self

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

    builder = StimuliGroups()
    builder.load(args.inputfile).build()

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


