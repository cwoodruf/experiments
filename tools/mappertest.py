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

def dumpMN(cubeset, catmap, r):
	"""
	dump out one of the category maps
	"""
	a = json.loads(r)
	# print a[cubeset][catmap]
	for cube in a[cubeset][catmap]:
		sides = []
		cat = ""
		for side in cube:
			cat = side['cat']
			sides.append(side['shape'])
		print cat, sides

print verify("login/{0}".format(os.environ["EXPMGRPW"]), "^(?!ERROR:)", "Not logged in")
print verify("test", "^tag \w+ auth \S+", "Login not saved")
countN(readurl("arrangementdims/3x2"), 3)
countN(readurl("arrangements/3x2"), 6)
dumpMN(4,4,readurl("arrangements/3x2"))


