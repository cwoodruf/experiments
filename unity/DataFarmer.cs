using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using UnityEngine;

public class DataFarmer 
{

    // 
    private static DataFarmer me = null;

    // buffer for incoming data
    private List<IDataFarmerObject> data = new List<IDataFarmerObject>();

    // SET BUFFER THRESHHOLD WHICH, WHEN MET, WILL STREAM DATA CHUNKS OUTWARD
    // this can be overridden from the config file
    private static int BUFFER_FULL = 10;
    private static int SAVE_RETRIES = 5;

    // Webclient needed to save data externally
    private WebClient webClient;

    // authorization code needed to talk to web client
    private string auth;

    // must be true if we are to save data externally
    private bool loggedin = false;
    public static readonly string NOT_LOGGED_IN = "ERROR: not logged in";

    // for GetConfig below
    public static int TRIALS = -1; // if TRIALS is <= 0 go on forever
    private static string CONFIG_FILE;
    private static string REMOTE_URI;
    private static string REMOTE_SECRET;
    private static string ARRANGEMENTS_FILE; // where to store maps of categories to cubes
    private static long FIRSTPARTICIPANT = -1;
    private static string ARRANGEMENT_DIMS = "3x2"; // type of stimuli to get
    private static readonly string DEFAULT_LOG = "df.csv";
    private static string LOCAL_LOG = DefaultLog();

    // Cubesets of cubes for counterbalancing stimuli
    public CubeArrangements CubeLists;

    // Use this for initialization - Creates a "virtual" game object.
    public static DataFarmer GetInstance()
    {
        if (me == null)
        {
            me = new DataFarmer();
        }
        return me;
    }

    // this particular instantiation assumes we are logging to an 
    // external server that is coordinating participant ids
    private DataFarmer()
    {
        Setup();
    }

    // logs in to external server and creates our identity for this run ...
    public void Setup()
    {
        GetConfig();
        Login();
        LoadCubes();
    }

    private static string GetDesktop()
    {
        return Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
    }

    private static string DefaultLog()
    {
        return string.Format(@"{0}\{1}", GetDesktop(), DEFAULT_LOG);
    }

    // use saved configuration data to set up external connection
    // data buffering and other things
    private static void GetConfig()
    {
        if (CONFIG_FILE == null)
        {
            CONFIG_FILE = string.Format(@"{0}\{1}", GetDesktop(), "experiments.config.txt");
        }

        if (!File.Exists(CONFIG_FILE)) return;

        Regex linePat = new Regex(@"(?<name>\w+)[=:\s](?<value>.*)");
        using (StreamReader conf = File.OpenText(CONFIG_FILE))
        {
            while (!conf.EndOfStream)
            {
                string line = conf.ReadLine();
                if (line.StartsWith("#") || line.StartsWith("//"))
                {
                    continue;
                }
                Match lineMatch = linePat.Match(line);
                if (!lineMatch.Success)
                {
                    continue;
                }
                string name = lineMatch.Groups["name"].ToString().ToLower();
                string value = Regex.Replace(lineMatch.Groups["value"].ToString(), @"\r\n?|\n", "");
                Regex dimsPat = new Regex(@"^\d+x\d+$");
                switch (name)
                {
                    case "url": case "uri": REMOTE_URI = value; break;
                    case "secret": case "password": REMOTE_SECRET = value; break;
                    case "log": LOCAL_LOG = value; break;
                    case "buffer": BUFFER_FULL = int.Parse(value); break;
                    case "arrangements": ARRANGEMENTS_FILE = value; break;
                    case "trials":
                        try
                        {
                            int.TryParse(value, out TRIALS);
                        } catch (Exception e)
                        {
                            TRIALS = -1;
                        }
                        break;
                    case "firstparticipant":
                        try
                        {
                            long.TryParse(value, out FIRSTPARTICIPANT);
                        } catch (Exception e)
                        {
                            FIRSTPARTICIPANT = -1;
                        }
                        break;
                    case "dims":
                        if (dimsPat.IsMatch(value)) { ARRANGEMENT_DIMS = value; }
                        else throw new FormatException("dims should be NxM");
                        break;
                    default: Debug.Log(string.Format("don't know what {0} is", name)); continue;
                }
                Debug.Log(string.Format("set '{0}' to '{1}'.\n", name, value));
            }
        }
    }

    // use this method to reset the configuration file before 
    public DataFarmer SetConfigFile(string fname)
    {
        CONFIG_FILE = fname;
        Debug.Log("reset config file to " + CONFIG_FILE);
        if (File.Exists(CONFIG_FILE))
        {
            Debug.Log("updating configuration");
            GetConfig();
        }
        return this;
    }

    // for counterbalancing - we want to give every participant a different set of cubes to learn
    // a place for the mapping data from categories to cubes
    // this must exist for the experiment to run
    public void LoadCubes()
    {
        if (!File.Exists(ARRANGEMENTS_FILE))
        {
            if (!ImportCubes())
            {
                throw new IOException("Could not download stimuli map");
            }
        }
        string arrangements;
        using (StreamReader reader = File.OpenText(ARRANGEMENTS_FILE))
        {
            arrangements = reader.ReadToEnd();
            CubeLists = new CubeArrangements(arrangements);
        }
    }

    // this will grab them from the external server as a huge json string which we save to file
    // subsequent runs will use this file rather than re-getting it so remove the "arrangements.json"
    // file if you want to refresh the data
    private bool ImportCubes()
    {
        string arrangements = GetRequest(string.Format("{0}/arrangements/{1}", REMOTE_URI, ARRANGEMENT_DIMS));
        Regex errPat = new Regex(@"^ERROR:");
        if (arrangements == null || arrangements == "" || errPat.IsMatch(arrangements))
        {
            return false;
        }
        File.WriteAllText(ARRANGEMENTS_FILE, arrangements);
        return true;
    }

    // make a participant id if we don't have one already
    public string NewParticipant()
    {
        if (loggedin)
            return GetRequest(string.Format("{0}/new", REMOTE_URI));
        return NOT_LOGGED_IN;
    }

    // what is the base participant id?
    public long FirstParticipant()
    {
        if (FIRSTPARTICIPANT <= 0)
        {
            string firstie = GetRequest(string.Format("{0}/first", REMOTE_URI));
            try
            {
                long.TryParse(firstie, out FIRSTPARTICIPANT);
            }
            catch (Exception e)
            {
                throw new InvalidCastException("can't get FIRSTPARTICIPANT - add a firstparticipant option in the config file?");
            }
        }
        return FIRSTPARTICIPANT;
    }

    // Saving the Data Chunk to File and remotely
    // on error does a lot of complaining and will throw an exception if no data can be saved
    public void Save(DataFarmerObject thingToSave, bool saveme=false)
    {

        // Since this section is called every frame, the data.add line will continue 
        // to receive a new line of data on every iteration until the BUFFER is reached
        data.Add(thingToSave);

        if (saveme || data.Count == BUFFER_FULL)
        {
            bool anythingsaved = false;
            // Serialize data structure
            string dataString = "";
            foreach (IDataFarmerObject o in data)
            {
                dataString += o.Serialize();
            }

            // update csv log on file path
            if (LOCAL_LOG != null)
            {
                try
                {
                    Debug.Log("Data Moving to File!");
                    using (StreamWriter file = File.AppendText(LOCAL_LOG))
                    {
                        file.Write(dataString);
                        anythingsaved = true;
                    }
                }
                catch (Exception e)
                {
                    Debug.Log(string.Format("failed to write to log: {0} {1}", e, e.Message));
                }
            }

            if (SaveRemotely(dataString))
            {
                anythingsaved = true;
            }

            data.Clear();
            if (!anythingsaved)
            {
                Debug.Log("ERROR: NO DATA COULD BE SAVED!");
                throw new Exception("no data can be saved");
            }
        }
    }

    // send remote data if we can
    private bool SaveRemotely(string dataString)
    {
        bool saved = false;
        try
        {
            if (!loggedin) Login();

            long participant = ParticipantStatus.GetInstance().GetParticipant();

            if (loggedin && participant >= 0)
            {
                // check if we succeeded and retry a limited number of times with backoff if we don't
                int tries = SAVE_RETRIES;
                do
                {
                    saved = false;
                    string uri = string.Format("{0}/save/{1}", REMOTE_URI, participant);
                    string result = PostRequest(uri, dataString);
                    Debug.Log("save result: " + result);
                    if (result.StartsWith("OK"))
                    {
                        Debug.Log("confirmed save");
                        saved = true;
                    }
                    else
                    {
                        tries--;
                        if (tries <= 0) break;
                        Debug.Log("failed trying to log in again " + tries + " tries left");
                        Thread.Sleep(SAVE_RETRIES - tries * 500); // ms to wait before trying again
                        Login();
                    }
                } while (loggedin && !saved);
                if (!saved)
                {
                    Debug.Log("ERROR: NOT ABLE TO SAVE DATA REMOTELY!");
                }
            }
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
        }
        return saved;
    }

    // various web related functions
    // gets a very tolerant web client 
    private WebClient GetNewWebClient()
    {
        // this line is needed for https to work with our self-signed certificates
        ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
        return new WebClient();
    }

    // logs in and as a side effect gets our auth cookie - needed for all other requests
    private bool Login()
    {
        loggedin = false;
        if (REMOTE_URI == null || REMOTE_SECRET == null)
        {
            Debug.Log("DataFarmer missing configuation needed to log in!");
            return false;
        }
        using (webClient = GetNewWebClient())
        {
            string content = webClient.DownloadString(makeNonce().Uri(string.Format("{0}/login", REMOTE_URI)));
            Debug.Log("login result: " + content);
            if (!content.Contains("ERROR:"))
            {
                loggedin = true;
            }
            WebHeaderCollection headers = webClient.ResponseHeaders;
            int i = 0;
            for (; i < headers.Count; i++)
            {
                Debug.Log(headers.GetKey(i) + ": " + headers.Get(i));
                if (headers.GetKey(i) == "Set-Cookie")
                {
                    auth = headers.Get(i);
                    Debug.Log(string.Format("{0}", auth));
                    break;
                }
            }
            webClient.Dispose();
        }
        return loggedin;
    }

    // tools for making basic requests - we must be logged in to use them
    // Post uses the http POST method and expects extra data to send
    private string PostRequest(string uri, string dataString)
    {
        string result = null;
        using (webClient = GetNewWebClient())
        {
            // if this auth cookie is invalid nothing will work ...
            webClient.Headers.Add("Content-Type", "text/plain");
            webClient.Headers.Add("Cookie", auth);
            result = webClient.UploadString(uri, "POST", dataString);
        }
        webClient.Dispose();
        return result;
    }

    // Get uses http's GET method and only needs a url
    private string GetRequest(string uri)
    {
        string result = null;
        using (webClient = GetNewWebClient())
        {
            webClient.Headers.Add("Content-Type", "text/plain");
            webClient.Headers.Add("Cookie", auth);
            result = webClient.DownloadString(uri);
        }
        webClient.Dispose();
        return result;
    }

    // how to hide sending the actual password over the network
    private Nonce makeNonce()
    {
        return new Nonce(REMOTE_SECRET);
    }

    // does some fancy stuff to use a random number to obscure our password
    // this class is effectively final: there is no way to change the code/nonce after instantiation
    private class Nonce
    {
        private int nonce;
        private string code;

        public Nonce(string secret)
        {
            System.Random random = new System.Random();
            nonce = random.Next(int.MaxValue);
            code = Encode(secret);
        }

        // another architecture would be to have MakeCode be a callback
        private string Encode(string secret)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                // ComputeHash - returns byte array  
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(MakeCode(secret)));

                // Convert byte array to a string   
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                code = builder.ToString();
            }
            return code;
        }

        // this can be made more complex but has to also be replicated on the remote server
        private string MakeCode(string secret)
        {
            return string.Format("{0}{1}", nonce, secret);
        }

        public string Uri(string baseUri)
        {
            return string.Format("{0}/{1}/{2}", baseUri, code, nonce);
        }
    }
}
