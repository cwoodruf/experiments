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
from itertools import permutations

debug = False
"""
Because we make multiple passes through add_arrangements 
we have to track some things globally:
- arrseen ensures that we haven't seen a given mapping of cubes to categories before
- cubesets keeps track of the top level stimuli we have created: these are 
  orientations of color axes - for the 3x2 color/shape map we have 6 described earlier
- cubesetcount is the index into the top level array in arrangements
- arrangements is the complete array of cubesets

A cubeset in this case is a mapping of a group of cubes to a set of categories.
The number of categories depends on the number of dimensions or axes for each "cube"
times the number of possible shapes represented.
"""
arrseen = {}
cubesets = {}
cubesetcount = -1
arrangements = {}

def add_arrangement(colorshapes):
	"""
	reads a map of color -> list of shapes
	makes experimental conditions where at least one shape is 
	an irrelevant feature of any given condition
	maps other features to each category in turn
	maps the position of each color in a 360 degree circle
	"""
        # see below in arrange_from_file, we make multiple passes
        # through the same data hence we rerun add_arrangements
        # and incrementally add to arrangements
        # arrseen, cubesets and cubesetcount are for tracking
        # where we are in processing
        # arrangements is what we eventually print out
	global arrseen
	global arrangements
	global cubesets
	global cubesetcount

        """
        this creates a series of rotations for each color axis
        0, 120, 240 or more depending on the number of subdivisiions
        the orientation is applied to each color axis to create the 6 different types of cubes
        The positions look like this to the viewer for 3 colors
        1.  r     2.  r     3.  g     4.  g     5.  b     6.  b
          b   g     g   b     r   b     b   r     g   r     r   g
        """
	positions = permutations([int(i*(360.0/len(colorshapes))) for i in xrange(len(colorshapes))])
        """
        ordinalities refers to the ordering of the colors for categorization
           r  b  g
        c1 0  0  0
        c1 0  0  1
        c2 0  1  0
        c2 0  1  1
        c3 1  0  0
        c3 1  0  1
        c4 1  1  0
        c4 1  1  1
        we would then repeat the same for b r g, g r b etc in the example above

        """
	ordinalities = list(permutations([j for j in xrange(len(colorshapes))]))
	colormap = colorshapes.keys()

	if debug:
		print colorshapes

        # combinations is used for debug output
	combinations = 0

        # positions is an array of [[120, 240, 0] ... representing the orientation of what the viewer sees
        # for each of these we then create a series of category mappings
	for position in positions:
		if debug: 
			print "new position set", position

                """
                each "colorperm" is an array that 
                represents a permutation of color axes for categorization
                this is independent of what people see but maps to the set of categories
                that they must infer 
                """
		for colorperm in ordinalities:
                        # get the shapes for all colorperm as a list of lists ...
			shapes = [colorshapes[colormap[colorperm[i]]] for i in xrange(len(colorperm))]
			if debug:
                            print "new ordinality list"
                            print "shapes", shapes

                        """
                        we walk through each category numbered from 1 to 2^(len(colorperm)-1)
                        and associate a cube with each color
                        """
			category = 0
                        
                        """
                        cubecount and allshapes keep track of where we are in the mapping of categories
                        allshapes - is the product of the number of shapes for each color 
                        we know that we have to make at least this many cubes 
                        """
			cubecount = 0
			allshapes = numpy.prod([len(shapes[i]) for i in xrange(len(shapes))])

                        """
                        block represents what we print out which is formatted to work
                        with both C# and matlab JSON tools. This represents a complete set of cubes
                        with their respective categories
                        """
			block = []
                        
                        """
			blockstrings is our ham handed method for finding duplicates
                        these are sorted string representations of each block that can be filtered
                        """
			blockstrings = []

                        """
			used to identify what group of cubes mapped to categories we are part of
                        it is turned into a string below to ensure we haven't produced a duplicate
                        """
			cubeset = []
			while cubecount < allshapes:
				if debug: 
					sys.stdout.write("{0}: ".format(cubecount))
                                # category string used in the output "c0, c1..."
				cat = "c{0}".format(category)
                                # a set of axes that define a "cube" this is a list of dicts 
				cubeline = []
                                # easy to sort version of cubeline which is just the values in order
				sortedcubeline = []
                                # sortable string representation of a cube
				cube = []
				for colorpermpos in xrange(len(colorperm)):
                                        """
                                        The following is the critical section for determining what shape to 
                                        use. Typically one color is a distractor where the color/shape combination
                                        does not have any meaningful association with a category. 
                                        In this case colorpermpos is the position in a given color permutation.
                                        We need to select a shape from the list of shapes associated with this color.
                                        We do this by calculating "divisor" which is the product of the number
                                        of shapes from our current position in the current color permutation. For 
                                        3 colors and 2 shapes:
                                        colorpermpos 0 -> 2 * 2 = 4
                                        colorpermpos 1 -> 2 
                                        colorpermpos 2 -> 1
                                        This ensures that the first color in colorperm gets its shape changed less frequently
                                        than the color in the second position and the color in the last position, the distractor,
                                        gets changed every time resulting in no meaningful association between color/shape and 
                                        category. 
                                        When we have an odd number of colors we end up with multiple distrators hence the 
                                        "lsk%2" being added to colorpermpos.
                                        To get the actual shape get the index into the array of shapes for the given color
                                        by dividing the current number of cubes by the divisor. We use modulus to prevent overflow.
                                        In the 3 color 2 shape case this should not happen.
                                        """
					lsk = len(shapes[colorpermpos])
					divisor = int(numpy.prod([len(shapes[l]) for l in xrange((colorpermpos+(lsk%2)),lsk)]))
					shapeidx = (cubecount / divisor) % lsk
					shape = shapes[colorpermpos][shapeidx]
                                        if debug:
                                            print "colorpermpos",colorpermpos, "lsk", lsk, "divisor", divisor, "shapeidx", shapeidx, "shape", shape

                                        # o is the index into the various arrays we are using to produce an axis
					o = colorperm[colorpermpos]

					# this is repeating categories but doing this to make it work
					# more elegantly in both C# and matlab which have very different ideas
					# about data structures
					rotation = position[o]
					color = colormap[o]

					# if debug: sys.stdout.write(str((category,colorpermpos,o,color,shape,rotation)))

                                        # this line is what we return when we send the JSON data out
                                        # note that the category "cat" is placed here to make using the JSON tools in matlab and C# work 
					cubeline.append({"cat":cat, "color":color, "shape":shape, "rotation":rotation})

                                        # these are sortable strings for tracking duplicates
					cube.append("{0:>3} {1} {2}".format(rotation, color, shape))
					sortedcubeline.append("{0} {1:>3} {2} {3}".format(cat, rotation, color, shape))

				if debug: 
                                    print

                                # this is where we determine if we've seen this cube/category mapping before
                                # and either add it to the output data or discard it.
				sortedline = sorted(sortedcubeline)
				cube = sorted(cube)
				if debug: 
                                    print sortedline
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
			if cubesetkey not in cubesets:
				cubesetcount += 1
				cubesets[cubesetkey] = cubesetcount
				thiscubeset = cubesetcount
			else:
				thiscubeset = cubesets[cubesetkey]
			
			# we take advantage of python's ability to make strings out of data 
			# and use the whole block as a key in a dictionary
			blockkey = sorted(blockstrings).__repr__()
			if blockkey in arrseen:
				continue 

			# if we sort the strings we can get rid of artificially different groups 
			arrseen[blockkey] = True

			if thiscubeset not in arrangements:
				arrangements[thiscubeset] = []

                        # finally add to the arrangements we have for this cubeset
			arrangements[thiscubeset].append(block)
	if debug: 
		print "total combinations",combinations

def readcolorshapes(inputfile):
	"""
	json decode an imput file
	we assume its of the form:
	{ 'color 1': [ 'shape 1', 'shape 2', ...], 'color 2': ['...',...]... }
	"""
	with open(inputfile, "r") as sh:
		try:
			colorshapes = json.load(sh)
		except Exception as e:
			print "failed to read json data - please check the format"
			return 
	return colorshapes

def arrange_from_file(inputfile):
	"""
	As Rollin discovered the ordering of the shapes per color
	can change the category/feature mappings
	in arrange_from_file we enumerate all permutations of shapes
	as some features are irrelevant this means that some 
	of these arrangements are duplicates
	in add_arrangement() we check for duplicates and do not include
	them
	"""
	colorshapes = readcolorshapes(inputfile)
	perms = {}
	colors = []
	permcount = 1
        # read our original map and, for each color, generate a list of shape permutations
        # keep track of the total number in permcount
	for color, shapes in colorshapes.iteritems():
		perms[color] = list(permutations(shapes))
		permcount *= len(perms[color])
		colors.append(color)

        # prods represents the product of the number of permutations at a given color position
        # in the 3 color 2 shape case this results in [4, 2, 1]
        # this ensures that each shape permutation gets used with every other permutation
	prods = [1 for pk in range(len(colorshapes))]
	pi = 0
	for color, shapes in perms.iteritems():
		for pj in range(pi):
			prods[pj] *= len(shapes)
		pi += 1

        if debug: 
            print "prods", prods

        # go through every permutation of shapes and create arrangements
        # for each set of permutations construct an equivalent "colorshapes"  
        # and generate arrangements for it, removing any duplicates
	for i in xrange(permcount):
		colorperm = {}
		for j, color in enumerate(colors):
			lp = len(perms[color])
                        # just using i % lp results in 1/2 the arrangements
			colorperm[color] = perms[color][(i/prods[j]) % lp]
		if debug: print colorperm

                # an arrangement is a mapping of cubes to categories
                # where each set of cubes has a specific color orientation
		add_arrangement(colorperm)

if __name__ == '__main__':

	parser = argparse.ArgumentParser()
	parser.add_argument("-d","--debug", help="print debug output", action="store_true")
	parser.add_argument("inputfile", 
		help="json object mapping colors to shapes "
			"should be in form of { \"color 1\":[\"shape 1\",...],...}")
	args = parser.parse_args()
	debug = args.debug

	arrangements = {}
	arrange_from_file(args.inputfile)

	print json.dumps(arrangements) # , indent=4)

