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
arrseen = {}

def arrangements(colorshapes):
	"""
	reads a map of color -> list of shapes
	makes experimental conditions where at least one shape is 
	an irrelevant feature of any given condition
	maps other features to each category in turn
	maps the position of each color in a 360 degree circle
	"""
	global arrseen
	c = len(colorshapes)
	positions = permutations([int(i*(360.0/c)) for i in xrange(c)])
	ordinalities = list(permutations([j for j in xrange(c)]))
	colormap = colorshapes.keys()

	if debug:
		print colorshapes

	arrangements = []
	combinations = 0
	for position in positions:
		if debug: 
			print "new position set", position
		for olist in ordinalities:
			shapes = [colorshapes[colormap[olist[i]]] for i in xrange(len(olist))]
			if debug:
				print "new ordinality list"
				print "shapes", shapes
			category = 0
			linecount = 0
			maxline = numpy.prod([len(shapes[i]) for i in xrange(len(shapes))])
			block = []
			# blockstrings is our ham handed method for finding duplicates
			blockstrings = []
			while linecount < maxline:
				if debug: 
					sys.stdout.write("{0}: ".format(linecount))
				cat = "c{0}".format(category)
				line = []
				sortedline = []
				for k in xrange(len(olist)):
					o = olist[k]
					lsk = len(shapes[k])
					divisor = int(numpy.prod([len(shapes[l]) for l in xrange((k+(lsk%2)),lsk)]))
					shapeidx = (linecount / divisor) % lsk
					shape = shapes[k][shapeidx]
					if debug: 
						sys.stdout.write(str((category,k,o,colormap[o],shape,position[o])))

					# this is repeating categories but doing this to make it work
					# more elegantly in both C# and matlab which have very different ideas
					# about data structures
					rotation = position[o]
					color = colormap[o]
					line.append({"cat":cat, "color":color, "shape":shape, "rotation":rotation})
					sortedline.append("{0} {1:<4} {2} {3}".format(cat, rotation, color, shape))

				if debug: print
				sortedline = sorted(sortedline)
				if debug: print sortedline
				blockstrings.append("{0}".format(sortedline))
				block.append(line)
				if k == len(olist)-1 and shapeidx == len(shapes[k])-1:
					category += 1
				linecount += 1
				combinations += 1

			# if we sort the strings we can get rid of artificially different groups 
			sortedblock = sorted(blockstrings)

			# we take advantage of python's ability to make strings out of data 
			# and use the whole block as a key in a dictionary
			if sortedblock.__repr__() in arrseen:
				continue 
			arrseen[sortedblock.__repr__()] = True

			arrangements.append(block)
	if debug: 
		print "total combinations",combinations

	return arrangements

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
	in arrangements() we check for duplicates and do not include
	them
	"""
	colorshapes = readcolorshapes(inputfile)
	perms = {}
	colors = []
	permcount = 1
	for color, shapes in colorshapes.iteritems():
		perms[color] = list(permutations(shapes))
		permcount *= len(perms[color])
		colors.append(color)

	prods = [1 for pk in range(len(colorshapes.keys()))]
	pi = 0
	for color, shapes in perms.iteritems():
		for pj in range(pi):
			prods[pj] *= len(shapes)
		pi += 1

	a = []
	for i in xrange(permcount):
		colorperm = {}
		for j, color in enumerate(colors):
			lp = len(perms[color])
			colorperm[color] = perms[color][(i/prods[j]) % lp]
		if debug: print colorperm
		a += arrangements(colorperm)
	return a

if __name__ == '__main__':

	parser = argparse.ArgumentParser()
	parser.add_argument("-d","--debug", help="print debug output", action="store_true")
	parser.add_argument("inputfile", 
		help="json object mapping colors to shapes "
			"should be in form of { \"color 1\":[\"shape 1\",...],...}")
	args = parser.parse_args()
	debug = args.debug

	arrangements = arrange_from_file(args.inputfile)

	print json.dumps(arrangements) # , indent=4)

