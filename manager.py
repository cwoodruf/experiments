#!/usr/bin/env python
from gevent.pywsgi import WSGIServer
from flask import Flask, request, render_template, make_response
from managerutils import *

app = Flask('experiments')

@app.route("/")
def default():
	"""
	by default don't do anything
	"""
	return "CS Lab\n"

@app.route("/login/<key>")
def login(key):
	if not is_key_valid(key, request.environ):
		time.sleep(10)
		return "ERROR: invalid key\n"
	resp = make_response()
	if save_auth(request, resp):
		resp.set_data("OK\n")
	else:
		resp.set_data("ERROR: could not finish login\n")
	return resp

@app.route("/new")
def new_part():
	if not check_auth_params(request):
		return "ERROR: not logged in\n";
	ip = addr(request)
	resp = make_response(new_participant(ip))
	return resp

@app.route("/new/<key>")
def start(key):
	"""
	if we provide the right key we will get a new participant id
	"""
	ip = addr(request)
	valid = check_auth_params(request)
	if not valid:
		login(key)
		resp = make_response(new_participant(ip))
		if not save_auth(request, resp):
			resp.set_data("ERROR: login save failed\n")
	else:
		resp = make_response(new_participant(ip))
	return resp

@app.route("/test")
def test():
	"""
	check to see if we are logged in
	"""
	valid = check_auth_params(request)
	if valid:
		return request.cookies["auth"]
	return "not logged in"

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
	if not check_auth_params(request):
		return "ERROR: not logged in\n"

	if request.headers['Content-Type'] == 'text/plain':
		ip = addr(request)
		data_file = data_filename(ip, part)
		with open(data_file, "a") as dh:
			dh.write(request.data)
		return "OK: saved {0} bytes to {1}\n".format(len(request.data), data_file)

	return "ERROR: unknown content-type: {0}\n".format(request.headers['Content-Type'])

if __name__ == '__main__':
	try:
		os.remove(part_lock_filename())
	except:
		pass

	# for the debug server uncomment this
	# app.run(debug=True,host='0.0.0.0',port=13524)

	# the following can handle much heavier traffic
	http_server = WSGIServer(('0.0.0.0', 13524), app)
	http_server.serve_forever()

