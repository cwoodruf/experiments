#!/usr/bin/env python
import json, urllib2, os, ssl, re
from cookielib import CookieJar

# ignore our crappy SSL implementation
ssl_context = ssl.create_default_context()
ssl_context.check_hostname = False
ssl_context.verify_mode = ssl.CERT_NONE

URLBASE = "https://localhost:13524"
opener = urllib2.build_opener(
	urllib2.HTTPCookieProcessor(CookieJar()),
	urllib2.HTTPSHandler(context=ssl_context)
)

def readurl(url):
	url = "{0}/{1}".format(URLBASE,url)
	print "checking",url
	response = opener.open(url)
	return response.read()

def countN(r, n):
	a = json.loads(r)
	try:
		assert(len(a)==n)
		print "found {0} items".format(n)
	except:
		print "ERROR: actual {0} expected {1}".format(len(a), n)

def verify(url, comparison, errmsg):
	response = readurl(url)
	m = re.match(comparison, response)
	if m is None:
		raise Exception(errmsg)
	return "OK"

def dumpMN(cubeset, catmap, r,cubenum=-1):
	"""
	dump out one of the category maps
	"""
	a = json.loads(r)
	# print a[cubeset][catmap]
	cubes = -1
	for cube in a[cubeset][catmap]:
		sides = []
		cat = ""
		cubes += 1
		if cubenum >= 0 and cubes != cubenum:
			continue
		for side in cube:
			cat = side['cat']
			sides.append("{0}{1}".format(side['color'],side['shape']))
		print cat, sides

print verify("login/{0}".format(os.environ["EXPMGRPW"]), "^(?!ERROR:)", "Not logged in")
print verify("test", "^tag \w+ auth \S+", "Login not saved")
countN(readurl("arrangementdims/3x2"), 3)
countN(readurl("arrangements/3x2"), 6)
arrs = json.loads(readurl("arrangements/3x2"))

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
for cubeset in range(len(arrs)):
	sels = {}
	for catmap, cats in enumerate(arrs[cubeset]):
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
	cubeset = cond % len(arrs)

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

		selections.append(arrs[cubeset][catmap])

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

