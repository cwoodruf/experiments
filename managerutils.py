from base64 import b64encode
import os, random, time, string

"""
The following functions help us manage who gets access to the system
generating new participant ids - perhaps the hard way
the authentication process is that the external host runs

 /new/<key>

where key is a string that is stored for that IP a file appdir/keys
which consists of:

 <key> <ip address>

pairs. If the key exists in the file for the IP address we make a cookie
with a random identifier that is used subsequently to authenticate the session.
The cookies are stored in appdir/auth as files with 

 <IP>-<auth_cookie>

as their name. A cron task should remove these files periodically.

When /new is run a new participant id is made. This id is just a monotonically
increasing integer that is stored in 3 files. Firstly, the last participant is 
stored in the last-participant.txt file. We use this number to create the next
participant id by incrementing it and storing it again in the file. We also keep a list
of which participant was created for which host in participants.csv. Lastly we keep
the last participant run by this host in running/<IP>.

"""

# sets up our application dir via environment variable
# we cannot assume that os.getcwd() will be sensible
# if this is run through an application server
if 'EXPERIMENTS_DIR' not in os.environ:
	appdir = os.getcwd()
else:
	appdir = os.environ['EXPERIMENTS_DIR']

if not os.path.isdir(appdir):
	raise ValueError("your appdir " + appdir + " is not a directory!")

for sub in ["running","auth","data"]:
	try:
		os.makedirs(os.path.join(appdir, sub))
	except Exception as e:
		if not os.path.isdir(os.path.join(appdir, sub)):
			raise Exception("ERROR: can't create subdirectory {0}: {1}".format(sub,e))

def addr(request):
	if 'REMOTE_ADDR' in request.environ:
		return request.environ['REMOTE_ADDR']

def is_key_valid(key, environ):
	key_file = os.path.join(appdir,"keys")
	if not os.path.isfile(key_file):
		return False
	
	with open(key_file , "r") as kh:
		for l in kh:
			try:
				k, ip = l.split()
				if k == key:
					if environ['REMOTE_ADDR'] == ip:
						return True
			except:
				continue
	return False

def auth_key_filename(ip, auth_key):
	return os.path.join(appdir,"auth",ip+"-"+auth_key);

def create_auth_params(ip):
	auth_key = b64encode("".join([random.choice(string.printable) for _ in range(32)]))
	auth_key_file = auth_key_filename(ip, auth_key)
	return auth_key, auth_key_file

def check_auth_params(req):
	if "auth" not in req.cookies: return False
	auth_key = req.cookies["auth"]
	ip = addr(req)
	auth_key_file = auth_key_filename(ip, auth_key)
	# we should check the age of the authorization but removing the files would also work
	return os.path.isfile(auth_key_file)

def save_auth(req, resp):
	"""
	creates an authentication file
	"""
	ip = addr(req)
	auth_key, auth_key_file = create_auth_params(ip)
	try:
		with open(auth_key_file, "w") as ah:
			ah.write("{0}".format(time.time()));
		resp.set_cookie("auth", auth_key)
		return True
	except:
		resp.set_cookie("auth","",expires=0)
	return False

def part_lock_filename():
	return os.path.join(appdir, "participants.csv.lock")

def last_part_filename():
	return os.path.join(appdir, "last-participant.txt")

def part_filename():
	return os.path.join(appdir, "participants.csv")

def running_filename(ip):
	return os.path.join(appdir, "running", ip)

def data_filename(ip, part):
	data_dir = os.path.join(appdir, "data", part)
	try:
		os.makedirs(data_dir)
	except:
		if not os.path.isdir(data_dir):
			raise Exception("{0} is not a directory\n".format(data_dir))

	filename = "{0}-{1}-{2}.txt".format(part, int(time.time()*1000.0), ip)
	return os.path.join(data_dir, filename)

def new_participant(ip):
	"""
	gets a new participant id in a way where we can have multiple hosts doing the same thing
	at the same time
	since file locking doesn't work on mac os 
	http://chris.improbable.org/2010/12/16/everything-you-never-wanted-to-know-about-file-locking/
	using a lock file to control access
	"""

	part_file = part_filename()
	last_part_file = last_part_filename()
	lock_file = part_lock_filename()
	running_file = running_filename(ip)
	slept = 1
	lock_key = "{0} {1}".format(ip, random.random())
	while os.path.isfile(lock_file):
		time.sleep(slept * 0.2)
		slept += 1
		if slept >= 20:
			return "TIMED OUT\n"

	with open(lock_file, "w+") as lh:
		lh.write(lock_key)

	with open(lock_file, "r") as lh:
		testkey = lh.read()
		if testkey != lock_key:
			return "TRY AGAIN\n"

	try:
		last_part = 0
		with open(last_part_file, "r") as ph:
			last_part = int(ph.read())
		os.remove(last_part_file)
		last_part += 1
	except:
		last_part = int(time.time() * 1000.0)

	with open(last_part_file, "w+") as ph:
		ph.write(str(last_part))

	with open(part_file, "a") as ph:
		ph.write("{0}, {1}\n".format(last_part, ip))

	with open(running_file, "w+") as rh:
		rh.write(str(last_part))

	if os.path.isfile(lock_file): 
		os.remove(lock_file)
	return str(last_part)

