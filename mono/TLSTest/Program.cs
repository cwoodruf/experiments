using System;
using System.Collections.Specialized;
using System.Net;
using System.Text;
using System.Runtime.Remoting.Messaging;
using System.Security.Cryptography;

/*
 * this program tests a TLS connection as well as the experiments.manager 
 * protocol for logging in and getting a participant id in one step
 * we test creating a random nonce and making a hash
 */
namespace TLSTest
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("TLS Test");
			string responsestring = "";
			Console.Write ("Host (default: https://localhost): ");
			string host = Console.ReadLine ();
			if (host == "") {
				host = "https://localhost";
			}
			Console.WriteLine ("using host " + host);
			Console.Write("Enter password: ");
			string password = Console.ReadLine();
			Random random = new Random ();
			int nonce = random.Next (int.MaxValue);
			string hash = "";
			string cookies = "";
			// Create a SHA256   
			using (SHA256 sha256Hash = SHA256.Create())  
			{  
				// ComputeHash - returns byte array  
				byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(string.Format("{0}{1}", nonce, password)));  

				// Convert byte array to a string   
				StringBuilder builder = new StringBuilder();  
				for (int i = 0; i < bytes.Length; i++)  
				{  
					builder.Append(bytes[i].ToString("x2"));  
				}  
				hash = builder.ToString();  
			}  
			string uribase = string.Format("{0}:13524", host);
			string uri = string.Format("{0}/new/{1}/{2}", uribase, hash, nonce);
			using (WebClient client = new WebClient ()) {
				try
			{
					// the following is only wanted for ignoring cert errors (e.g. cert is self-signed)
					ServicePointManager
						.ServerCertificateValidationCallback += 
							(sender, cert, chain, sslPolicyErrors) => true;
					responsestring = client.DownloadString(uri);
					WebHeaderCollection headers = client.ResponseHeaders;
					foreach (string key in headers.AllKeys) {
						Console.WriteLine(key + " = " + headers[key]);
						if (key == "Set-Cookie") cookies = headers[key];
					}
					client.Headers.Add(HttpRequestHeader.Cookie, cookies);
					responsestring += "\ntest of connection\n" + client.DownloadString(uribase+"/test");
					for (int j=0; j<10; j++) responsestring += "\nanother new participant\n" + client.DownloadString(uribase+"/new");
				}
				catch (Exception e)
				{
					Console.WriteLine(e.Message);
				}
				finally
				{
					Console.Write(string.Format("{0}, {1}, {2}\n", uri, client.ResponseHeaders.ToString(), responsestring));
				}
			}
		}
	}
}
