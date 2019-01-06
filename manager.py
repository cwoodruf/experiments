#!/usr/bin/python
import re, json
from gevent.pywsgi import WSGIServer
from flask import Flask, request, render_template, make_response, jsonify, url_for
from managerutils import *

app = Flask('experiments')

@app.route("/favicon.ico")
def favicon():
	return ""

@app.route("/")
def default():
	"""
	by default don't do anything
	"""
	return "CS Lab\n"

@app.route("/api")
@app.route("/help")
def api_helper():
	"""
	list all the api calls and their arguments
	"""
	import urllib
	output = []
	seen = {}
	for rule in app.url_map.iter_rules():
		options = {}
		for arg in rule.arguments:
			options[arg] = "[{0}]".format(arg)
		methods = ",".join(rule.methods)
		url = url_for(rule.endpoint, **options)
		line = urllib.unquote("{:20s} {}".format(methods, url))
		if line in seen:
			continue
		seen[line] = True
		output.append(line)

	return "<pre>{0}</pre>".format("\n".join(sorted(output)))

@app.route("/login/<key>/<nonce>")
@app.route("/login/<key>",defaults={'nonce': None})
def login(key, nonce):
	resp = make_response()
	tag = is_key_valid(key, request.environ, nonce)
	if tag is None or not tag:
		resp.set_data("ERROR: invalid key\n")
	else:
		result = save_auth(tag, request, resp)
		if not result:
			resp.set_data("ERROR: could not finish login\n")
		else:
			resp.set_data(result)
	return resp

@app.route("/new")
def new_part():
	tag = check_auth_params(request)
	if tag == False:
		return "ERROR: not logged in\n";
	ip = addr(request)
	resp = make_response(new_participant(tag, ip))
	return resp

@app.route("/new/<key>/<nonce>")
@app.route("/new/<key>",defaults={'nonce': None})
def start(key, nonce):
	"""
	if we provide the right key we will get a new participant id
	"""
	ip = addr(request)
	tag = check_auth_params(request)
	if not tag:
		tag = is_key_valid(key, request.environ, nonce)
		if not tag:
			return "ERROR: invalid key\n"
		resp = make_response(new_participant(tag, ip))
		if not save_auth(tag, request, resp):
			resp.set_data("ERROR: login save failed\n")
	else:
		resp = make_response(new_participant(tag, ip))
	return resp

@app.route("/test")
def test():
	"""
	check to see if we are logged in
	"""
	tag = check_auth_params(request)
	if not tag:
		return "not logged in"
	return "tag {0} auth cookie {1}".format(tag, request.cookies["auth"])

@app.route("/last")
def last_participant():
	"""
	tell us the participant id of the last participant
	also tells us the globally last participant
	"""
	if not check_auth_params(request):
		return "ERROR: not logged in\n";
	ip = addr(request)
	try:
		with open(last_part_filename(), "r") as lh:
			last_part = lh.read()
		with open(running_filename(ip), "r") as rh:
			running_part = rh.read()
	except:
		return "ERROR reading data files\n"
	return "last participant for {0}: {1}, global last: {2}\n".format(
			ip, running_part, last_part)
 	
@app.route("/save/<part>", methods=["POST"])
def save_data(part):
	"""
	saves data for a participant
	note we don't do any data checking
	example test:
	curl -c cookies -b cookies -H 'content-type: text/plain' -XPOST http://localhost:13524/save/1234 -d "hi"
	"""
	try:
		testpart = int(part)
	except:
		raise ValueError("participant id was not an integer")

	if not check_auth_params(request):
		return "ERROR: not logged in\n"

	if request.headers['Content-Type'] == 'text/plain':
		ip = addr(request)
		data_file = data_filename(ip, part)
		with open(data_file, "a+") as dh:
			dh.write(request.data)
		return "OK: saved {0} bytes to {1}\n".format(len(request.data), data_file)

	return "ERROR: unknown content-type: {0}\n".format(request.headers['Content-Type'])

amap = {}
@app.route("/arrangements/<dims>")
def print_arrangements(dims):
	"""
	this generates a json array of arrays 
	with the groups of stimuli for each trial
	we want to have each way of presenting 
	the color/shape position arrangements
	be unique to only 1 or 2 participants
	"""
	if not check_auth_params(request):
		return jsonify({"ERROR": "not logged in"})

	if not re.match('^\d+x\d+\w*$', dims):
		return jsonify({"ERROR": "bad dimensions"})

	global amap
	dimsfile = "tools/{0}.json".format(dims)
	if not os.path.isfile(dimsfile):
		return jsonify({"ERROR": "missing dim data"})

	try:
		import tools.mapper as m
		if dimsfile in amap:
			arrangements = amap[dimsfile]
		else:
			arrangements = m.arrange_from_file(dimsfile)
			amap[dimsfile] = arrangements
	except Exception as e:
		return jsonify({"ERROR": e})

	return jsonify(arrangements)

@app.route("/arrangementdims")
def arrangement_files():
	"""
	prints a list of arrangement files
	that can be used by the /arrangements/<dims> call
	"""
	if not check_auth_params(request):
		return jsonify({"ERROR": "not logged in"})

	dims = []
	for (dirpath, dirnames, filenames) in os.walk("tools"):
		for filename in filenames:
			m = re.match("^(\d+x\d+)\.json", filename)
			if m is None: continue
			dims.append(m.group(1))

	return jsonify(dims)

@app.route("/arrangementdims/<dims>")
def print_arrangementdims(dims):
	"""
	dumps one of the dimensions files used by /arrangements/<dims>
	"""
	if not check_auth_params(request):
		return jsonify({"ERROR": "not logged in"})

	if not re.match('^\d+x\d+\w*$', dims):
		return jsonify({"ERROR": "bad dimensions"})

	dimsfile = "tools/{0}.json".format(dims)
	if not os.path.isfile(dimsfile):
		return jsonify({"ERROR": "missing dim data"})

	try:
		with open(dimsfile, "r") as df:
			return jsonify(json.load(df))
	except Exception as e:
		return jsonify({"ERROR": "cannot read file: {0}".format(e)}) 	

if __name__ == '__main__':
	try:
		os.remove(part_lock_filename())
	except:
		pass

	# for the debug server uncomment this
	# app.run(debug=True,host='0.0.0.0',port=13524)

	# the following can handle much heavier traffic
	ssl_args={
		'keyfile':os.path.join(appdir, 'certs', 'MyKey.key'), 
		'certfile':os.path.join(appdir, 'certs', 'MyCertificate.crt')
		#'keyfile':'/Users/collector/certbot/config/live/cslab.psyc.sfu.ca/privkey.pem',
		#'certfile':'/Users/collector/certbot/config/live/cslab.psyc.sfu.ca/fullchain.pem'
	}
	use_tls = True
	for k in ['keyfile','certfile']:
		if os.path.isfile(ssl_args[k]):
			print ssl_args[k],"exists"
		else:
			use_tls = False
			break
	if use_tls:
		print "using TLS"
		http_server = WSGIServer(('0.0.0.0', 13524), app, **ssl_args)
	else:
		print "running without TLS"
		http_server = WSGIServer(('0.0.0.0', 13524), app)
	http_server.serve_forever()

