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
from itertools import permutations

class Arrangements(object):

    def __init__(self, colorshapes):
        """
        reads in a dict of dimensions/axes (colors) and states for those dimensions (shapes)
        most of the object members are for tracking processing except arrangements
        which are what this class builds
        """
        self.colorshapes = colorshapes
        self.arrseen = {}
        self.cubesets = {}
        self.cubesetcount = -1
        self.arrangements = {}

    def add_arrangement(self):
        """
        builds a group of maps of a cohesive set of dimensions in a specific state
        because these dimensions relate to a visual stimulus arrangements of 
        the dimensions in space are considered distinct. For a specific spatial arrangement
        the set of states of each dimension is mapped to a set of categories.

        TODO: These sets of mappings are really static so we could save time by generating this
        once and then changing the location of each dimension.

        see below in arrange_from_file, we make multiple passes
        through the same data hence we rerun add_arrangements
        and incrementally add to arrangements
        arrseen, cubesets and cubesetcount are for tracking
        where we are in processing
        arrangements is what we eventually print out
        """

        positions = permutations([int(i*(360.0/len(self.colorshapes))) for i in xrange(len(self.colorshapes))])
        ordinalities = list(permutations([j for j in xrange(len(self.colorshapes))]))
        colormap = self.colorshapes.keys()

        logging.debug(self.colorshapes)

        # combinations is used for debug output
        combinations = 0

        # positions is an array of [[120, 240, 0] ... representing the orientation of what the viewer sees
        # for each of these we then create a series of category mappings
        for position in positions:
            logging.debug("new position set %s", str(position))

            for colorperm in ordinalities:
                # get the shapes for all colorperm as a list of lists ...
                shapes = [self.colorshapes[colormap[colorperm[i]]] for i in xrange(len(colorperm))]

                logging.debug("new ordinality list: shapes %s" % shapes)

                category = 0
                
                cubecount = 0
                allshapes = numpy.prod([len(shapes[i]) for i in xrange(len(shapes))])

                block = []
                
                blockstrings = []

                cubeset = []
                while cubecount < allshapes:

                    # category string used in the output "c0, c1..."
                    cat = "c{0}".format(category)
                    # a set of axes that define a "cube" this is a list of dicts 
                    cubeline = []
                    # easy to sort version of cubeline which is just the values in order
                    sortedcubeline = []
                    # sortable string representation of a cube
                    cube = []
                    for colorpermpos in xrange(len(colorperm)):
                        lsk = len(shapes[colorpermpos])
                        divisor = int(numpy.prod([len(shapes[l]) for l in xrange((colorpermpos+(lsk%2)),lsk)]))
                        shapeidx = (cubecount / divisor) % lsk
                        shape = shapes[colorpermpos][shapeidx]
                        logging.debug(
                            "colorpermpos %s lsk %s divisor %s shapeidx %s shape %s", 
                            colorpermpos, lsk, divisor, shapeidx, shape
                        )

                        # o is the index into the various arrays we are using to produce an axis
                        o = colorperm[colorpermpos]

                        # this is repeating categories but doing this to make it work
                        # more elegantly in both C# and matlab which have very different ideas
                        # about data structures
                        rotation = position[o]
                        color = colormap[o]

                        # this line is what we return when we send the JSON data out
                        # note that the category "cat" is placed here to make using the JSON tools in matlab and C# work 
                        cubeline.append({"cat":cat, "color":color, "shape":shape, "rotation":rotation})

                        # these are sortable strings for tracking duplicates
                        cube.append("{0:>3} {1} {2}".format(rotation, color, shape))
                        sortedcubeline.append("{0} {1:>3} {2} {3}".format(cat, rotation, color, shape))

                    # this is where we determine if we've seen this cube/category mapping before
                    # and either add it to the output data or discard it.
                    sortedline = sorted(sortedcubeline)
                    cube = sorted(cube)

                    logging.debug(sortedline)

                    blockstrings.append("{0}".format(sortedline))
                    cubeset.append(cube)
                    block.append(cubeline)

                    # change the category when we are at the last color and shape
                    if colorpermpos == len(colorperm)-1 and shapeidx == len(shapes[colorpermpos])-1:
                        category += 1

                    # for 3 colors and 2 shapes we'd expect 8 cubes
                    cubecount += 1
                    combinations += 1


                # identify what set of cubes we represent
                cubeset = sorted(cubeset)
                cubesetkey = cubeset.__repr__()

                # because we want an array of unique stimuli based on the orientation of
                # the cube we keep a count of these in cubesetcount 
                # this is then used as an index into the to level of the returned array or arrangements
                if cubesetkey not in self.cubesets:
                    self.cubesetcount += 1
                    self.cubesets[cubesetkey] = self.cubesetcount
                    thiscubeset = self.cubesetcount
                else:
                    thiscubeset = self.cubesets[cubesetkey]
                
                # we take advantage of python's ability to make strings out of data 
                # and use the whole block as a key in a dictionary
                blockkey = sorted(blockstrings).__repr__()
                if blockkey in self.arrseen:
                    continue 

                # if we sort the strings we can get rid of artificially different groups 
                self.arrseen[blockkey] = True

                if thiscubeset not in self.arrangements:
                    self.arrangements[thiscubeset] = []

                # finally add to the arrangements we have for this cubeset
                self.arrangements[thiscubeset].append(block)

        logging.debug("total combinations %s", combinations)

    def build(self):
        """
        Takes the map of dimensions/axes (colors) and states (shapes)
        and for each permutation of the list of shapes per color, builds
        a set of stimuli mapped to categories rotated through each possible
        position of the dimensions
        """
        perms = {}
        colors = []
        permcount = 1
        # read our original map and, for each color, generate a list of shape permutations
        # keep track of the total number in permcount
        for color, shapes in self.colorshapes.iteritems():
            perms[color] = list(permutations(shapes))
            permcount *= len(perms[color])
            colors.append(color)

        # prods represents the product of the number of permutations at a given color position
        # in the 3 color 2 shape case this results in [4, 2, 1]
        # this ensures that each shape permutation gets used with every other permutation
        prods = [1 for pk in range(len(self.colorshapes))]
        pi = 0
        for color, shapes in perms.iteritems():
            for pj in range(pi):
                prods[pj] *= len(shapes)
            pi += 1

        logging.debug("prods %s", prods)

        # go through every permutation of shapes and create arrangements
        # for each set of permutations construct an equivalent "colorshapes"  
        # and generate arrangements for it, removing any duplicates
        for i in xrange(permcount):
            colorperm = {}
            for j, color in enumerate(colors):
                lp = len(perms[color])
                # just using i % lp results in 1/2 the arrangements
                colorperm[color] = perms[color][(i/prods[j]) % lp]

            logging.debug(colorperm)

            # an arrangement is a mapping of cubes to categories
            # where each set of cubes has a specific color orientation
            self.add_arrangement()

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
    parser.add_argument("inputfile", 
    help="json object mapping colors to shapes "
        "should be in form of { \"color 1\":[\"shape 1\",...],...}")
    args = parser.parse_args()
    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.ERROR)

    builder = Arrangements(readcolorshapes(args.inputfile))
    builder.build()

    print json.dumps(builder.arrangements) # , indent=4)

