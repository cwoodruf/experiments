#!/usr/bin/env python
from mapper import arrange_from_file, arrangements
arrange_from_file("3x2.json")

# tacked on this code to hopefully counterbalance our cubes/answers
conditions = 28
print "counterbalancing conditions",conditions

# basic rules: make sure the number of times a cubeset is used is as even as possible
# next make sure the irrelevant feature is equally each color

# this "random" arrangement works out to evenly distributed irrelevant features
from random import Random
rand = Random(11)
colrange = conditions / 3
rgb = [c for c in ['r','g','b'] for r in range(colrange)] + ['r', 'r', 'g']

# turns out we only really want to look at each cubeset in turn 
# change 1 to another number to select multiple catmaps per cubeset
cubesample = [1 for x in range(conditions)]

# find out which cubes have which irrelevant feature
# we only use each of these once
allsels = []
for cubeset in range(len(arrangements)):
	sels = {}
	for catmap, cats in enumerate(arrangements[cubeset]):
		# pick the last color of the first cube to get irrelevant feature
		col = cats[0][2]['color']
		if col not in sels:
			sels[col] = []
		sels[col].append(catmap)
	allsels.append(sels)

# our current condition
cond = 1
# all selections so we can check irrelevant feature later
selections = []
for i in range(len(cubesample)):
	# we rotate through cube sets based on condition
	cubeset = cond % len(arrangements)

	count = 0
	while count < cubesample[cubeset] and cond <= conditions:
		# color of irrelevant feature
		col = rgb[cond]

		# which catmap we want
		selected = cond % len(allsels[cubeset][col])
		catmap = allsels[cubeset][col][selected]

		# enforce only using each catmap once
		del(allsels[cubeset][col][selected])

		count += 1

		print "condition",cond,"cubeset",cubeset,"catmap",catmap
		cond += 1
		if cond > conditions: break

		selections.append(arrangements[cubeset][catmap])

	if cond > conditions: break

print "sanity check: count irrelevant features"
d = {}
for cs in selections:
	for c in cs:
		col = c[2]['color']
		if col not in d:
			d[col] = 0
		d[col] += 1
print d

