#!/usr/bin/env python
"""
This tool takes as input 
- a list of groups of shapes + colors

It is assumed that the largest ordinality is always an irrelevant feature
i.e. it will be represented equally in each category.
The relevant features must uniquely map to each feature. The irrelevant
feature should never map to a specific sub-group of features.

The number of positions and the number of columns directly relate to each group of shapes.
The number of categories depends on the number of combinations of groups. 
The number of conditions relating to a category relates to the size of the groups.
We expect groups to always be the same size.

It outputs an exhaustive inventory of categories and their related shapes.
One group of category shape mappings represents an experimental condition.
"""
import json, sys, os, numpy
import argparse
from itertools import permutations

parser = argparse.ArgumentParser()
parser.add_argument("-d","--debug", help="print debug output", action="store_true")
parser.add_argument("inputfile", help="json object mapping colors to shapes should be in form of { \"color 1\":[\"shape 1\",...],...}")
args = parser.parse_args()
debug = args.debug

with open(args.inputfile, "r") as sh:
	try:
		colorshapes = json.load(sh)
	except Exception as e:
		print "failed to read json data - please check the format"
		sys.exit(1)

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
		while linecount < maxline:
			if debug: 
				sys.stdout.write("{0}: ".format(linecount))
			line = []
			for k in xrange(len(olist)):
				o = olist[k]
				lsk = len(shapes[k])
				divisor = int(numpy.prod([len(shapes[l]) for l in xrange((k+(lsk%2)),lsk)]))
				shapeidx = (linecount / divisor) % lsk
				shape = shapes[k][shapeidx]
				if debug: 
					sys.stdout.write(str((category,k,o,colormap[o],shape,position[o])))
				line.append((colormap[o], shape, position[o]))
			if debug: print
			block.append(("category{0}".format(category), line))
			if k == len(olist)-1 and shapeidx == len(shapes[k])-1:
				category += 1
			linecount += 1
			combinations += 1
		arrangements.append(block)
if debug: 
	print "total combinations",combinations
print json.dumps(arrangements) # , indent=4)

