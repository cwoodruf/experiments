"""
The following functions help us manage who gets access to the system
generating new participant ids (perhaps the hard way).
The authentication process is that the external host runs

 /login/<key> or /login/<hashed key>/<nonce>

where key is a string that is stored for that IP a file appdir/keys
which consists of:

 <key> <tag> <ip address>

lines. If the key exists in the file for the IP address we make a cookie
with a random identifier that is used subsequently to authenticate the session.
The cookies are stored in appdir/auth as files with 

 <IP>-<auth_cookie>

as their name. A cron task should remove these files periodically.

When /new is run a new participant id is made for the given tag. 
This id is just a monotonically increasing integer that is stored in 3 files. 
Firstly, the last participant is stored in the last-participant.txt file. 
We use this number to create the next participant id by incrementing it and 
storing it again in the file. We also keep a list of which participant 
was created for which host in participants.csv. Lastly we keep
the last participant run by this host in running/<IP>.

Change the last-participant.txt file to start participant numbers at a specific value.

"""
from base64 import b64encode
from glob import glob
import os, sys, random, time, string, hashlib, urllib

debug = False;

# sets up our application dir via environment variable
# we cannot assume that os.getcwd() will be sensible
# if this is run through an application server
if 'EXPERIMENTS_DIR' not in os.environ:
	appdir = os.getcwd()
else:
	appdir = os.environ['EXPERIMENTS_DIR']

if not os.path.isdir(appdir):
	raise ValueError("your appdir " + appdir + " is not a directory!")

for sub in ["participants","auth","data",os.path.join("data","ips")]:
	try:
		os.makedirs(os.path.join(appdir, sub))
	except Exception as e:
		if not os.path.isdir(os.path.join(appdir, sub)):
			raise Exception("ERROR: can't create subdirectory {0}: {1}".format(sub,e))

nonce_seen = {}

def key_filename():
	return os.path.join(appdir,"keys")

def read_keys():
	"""
	read the keys file - will have to restart to add keys
	"""
	keys = {}
	with open(key_filename(), "r") as kh:
		for l in kh:
			l = l.strip()
			if l.startswith("#"): continue
			try:
				key, tag, ip = l.split(" ")
				keys[ip] = { "key": key, "tag": tag }
			except:
				print "could not read:", l
	return keys
		
keys = read_keys()

def addr(request):
	if 'REMOTE_ADDR' in request.environ:
		return request.environ['REMOTE_ADDR']

def valid_nonce(nonce):
	"""
	validates the nonce - in this case whether we saw it 
	we don't keep any evidence between runs of the server
	"""
	if nonce is None: return True
	global nonce_seen
	if nonce in nonce_seen:
		 return False
	nonce_seen[nonce] = True
	if debug: print "nonce ok"
	return True

def create_hash(key, nonce, hashlen):
	"""
	makes a hash using a nonce
	in our case these are pretty simple: hash(nonce + key)
	"""
	if nonce is None: return key
	noncekey = "{0}{1}".format(nonce, key)
	if hashlen == 32:
		return hashlib.md5(noncekey).hexdigest()
	elif hashlen == 40:
		return hashlib.sha1(noncekey).hexdigest()
	elif hashlen == 56:
		return hashlib.sha224(noncekey).hexdigest()
	elif hashlen == 64:
		return hashlib.sha256(noncekey).hexdigest()
	elif hashlen == 128:
		return hashlib.sha512(noncekey).hexdigest()
	else: 
		raise ValueError("unknown hash length")

def is_key_valid(key, environ, nonce=None):
	"""
	for logging in: checks the key file for our key
	if we are using a hashed key use create_hash to 
	build a hash for comparison
	"""
	key_file = key_filename()
	if not os.path.isfile(key_file):
		return False
	
	ip = environ['REMOTE_ADDR']

	if ip not in keys: return False
	if not valid_nonce(nonce): return False
	ktest = create_hash(keys[ip]['key'], nonce, len(key))
	if ktest == key and 'tag' in keys[ip]:
		return keys[ip]['tag']

	return False

def auth_key_filename(ip, auth_key):
	"""
	where we actually store the authentication key
	typically the key is the file name
	the file will contain some useful metadata if anything
	"""
	authdir = os.path.join(appdir,"auth")
	return os.path.join(authdir,ip+"-"+urllib.quote_plus(auth_key)), os.path.join(authdir,ip+"*")

def create_auth_params(tag, ip):
	"""
	creates a random session key used for a study run
	this is a file that contains some useful session data
	"""
	auth_key = b64encode("".join([random.choice(string.printable) for _ in range(32)]))
	auth_key_file, auth_pat = auth_key_filename(ip, auth_key)
	for a in glob(auth_pat):
		try:
			os.unlink(a)
		except Exception as e:
			print "cannot unlink",a,"because of",e
	with open(auth_key_file, "w+") as ah:
		ah.write(tag)
	return auth_key, auth_key_file

def check_auth_params(req):
	"""
	search our cookies for the random session key
	look for the file and read any metadata in the file
	"""
	ip = addr(req)
	# sys.stdout.write("checking {0}\n".format(req.cookies))
	if "auth" not in req.cookies: return False
	auth_key = req.cookies["auth"]
	auth_key_file, auth_pat = auth_key_filename(ip, auth_key)
	# we should check the age of the authorization but removing the files would also work
	if os.path.isfile(auth_key_file):
		with open(auth_key_file, "r") as ah:
			tag = ah.read()
			return tag
	return False

def save_auth(tag, req, resp):
	"""
	creates an authentication file
	also sets the cookie with the session key
	"""
	ip = addr(req)
	auth_key, auth_key_file = create_auth_params(tag, ip)
	try:
		resp.set_cookie("auth", auth_key)
		return auth_key
	except:
		resp.set_cookie("auth","",expires=0)
	return False

def part_dir(tag):
	"""
	base directory for saving data for experiments
	"""
	d = os.path.join(appdir, "participants", tag)
	if os.path.isfile(d):
		raise Exception("{0}: should be a directory!".format(d))
	if not os.path.isdir(d):
		os.makedirs(d)
	return d

def part_lock_filename(tag):
	"""
	lock file for creating a new participant id
	if this does not get deleted between uses it will
	block anyone else making a new participant id
	"""
	return os.path.join(part_dir(tag), "participants.csv.lock")

def last_part_filename(tag):
	"""
	this file tracks the last participant number
	if we want to arbitrarily start numbering participants
	we can set the number in this file
	"""
	return os.path.join(part_dir(tag), "last-participant.txt")

def part_filename(tag):
	"""
	a list of which participants actually used which host
	"""
	return os.path.join(part_dir(tag), "participants.csv")

def data_dir(tag, ip):
	data_dir = os.path.join(part_dir(tag), "data", ip)
	if os.path.isfile(data_dir):
		raise Exception("data dir {0} is a file!".format(data_dir))
	if not os.path.isdir(data_dir):
		os.makedirs(data_dir)
	return data_dir
	
def last_data_filename(ip, tag):
	"""
	record of the last data file for a given ip address
	"""
	return os.path.join(data_dir(tag, ip), "{0}-latest.txt".format(ip))

def data_filename(ip, part):
	"""
	create a file name for a data file
	"""
	if ip not in keys or 'tag' not in keys[ip]:
		raise Exception("missing data on ip {0}".format(ip))

	tag = keys[ip]['tag']
	filename = "{0}-{1}.txt".format(ip, part)
	ddir = data_dir(tag, ip)
	fullpath = os.path.join(ddir, filename)

	with open(last_data_filename(ip, tag), "w+") as df:
		df.write(fullpath)

	return fullpath

def new_participant(tag, ip):
	"""
	gets a new participant id in a way where we can have multiple hosts doing the same thing
	at the same time
	since file locking doesn't work on mac os 
	http://chris.improbable.org/2010/12/16/everything-you-never-wanted-to-know-about-file-locking/
	using a lock file to control access
	"""
	part_file = part_filename(tag)
	last_part_file = last_part_filename(tag)
	lock_file = part_lock_filename(tag)
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
		last_part = 1 # was: int(time.time() * 1000.0)

	with open(last_part_file, "w+") as ph:
		ph.write(str(last_part))

	with open(part_file, "a+") as ph:
		ph.write("{0}, {1}\n".format(last_part, ip))

	if os.path.isfile(lock_file): 
		os.remove(lock_file)
	return str(last_part)

