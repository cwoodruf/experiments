import json
debug = False

# map.json is the output of the 3x2 arrangements  

with open("map.json", "r") as f:
	map = json.load(f)

irrelevant = {}
o = {0:"forward",120:"right",240:"up"}
for i, cubeset in enumerate(map):
	for j, categorymap in enumerate(cubeset):
		cscm = 'cubeset={0}/catmap={1}'.format(i,j)
		if cscm not in irrelevant:
			if debug: print "cscm",cscm
			irrelevant[cscm] = {}
		axis2cat = {}
		irrot = None
		for k, cube in enumerate(categorymap):
			for axis in cube:
				if axis['color'] not in axis2cat:
					axis2cat[axis['color']] = {}
				if axis['cat'] not in axis2cat[axis['color']]:
					axis2cat[axis['color']][axis['cat']] = {}
				axis2cat[axis['color']][axis['cat']][axis['shape']] = 1
				if len(axis2cat[axis['color']][axis['cat']].keys()) >= 2:
					irrot = o[axis['rotation']]
					if debug: print irrot,"is irrelevant"
					break
			if irrot is not None:
				break

		for k, cube in enumerate(categorymap):
			byrot = sorted(cube, key=lambda x: x['rotation'])
			# if debug: print byrot
			ct = 'cat: {0} cube:/{1}'.format(
					cube[0]['cat'],
					'/'.join([a['color']+a['shape'] for a in byrot])
			)
			if debug: print ct
			irrelevant[cscm][ct] = irrot
		
print json.dumps(irrelevant, indent=4, sort_keys=True)

