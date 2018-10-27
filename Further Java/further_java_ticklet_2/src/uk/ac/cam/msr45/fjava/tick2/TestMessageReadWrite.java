package uk.ac.cam.msr45.fjava.tick2;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

class TestMessageReadWrite {
 
    static boolean writeMessage(String message, String filename) {
	//Create an instance of "TestMessage" with "text" set
	//      to "message" and serialise it into a file called "filename".
	//      Return "true" if write was successful; "false" otherwise
        TestMessage testMessage = new TestMessage();
        testMessage.setMessage(message);
        ObjectOutputStream out  = null;
        try {
            out = new ObjectOutputStream(new FileOutputStream(filename));        out.writeObject(testMessage);
            out.writeObject(testMessage);
            out.close();
        } catch (IOException e) {
           return false;
        }
	return true;
    }

    static String readMessage(String location) {
	//If "location" begins with "http://" or "https://" then
	// attempt to download and deserialise an instance of
	// TestMessage; you should use the java.net.URL and
	// java.net.URLConnection classes.  If "location" does not
	// begin with "http://" or "https://" attempt to deserialise
	// an instance of TestMessage by assuming that "location" is
	// the name of a file in the filesystem.
	//
	// If deserialisation is successful, return a reference to the 
	// field "text" in the deserialised object. In case of error, 
	// return "null".
        ObjectInputStream in;
        if(location.startsWith("http://") || location.startsWith("https://")){
            //location is a URL
            try {
                URL website = new URL(location);
                 in = new ObjectInputStream(website.openConnection().getInputStream());
            } catch (IOException e) {
                e.printStackTrace();
                return null;

            }

        }
        else{
            //location is a file
            try {
                in = new ObjectInputStream(new FileInputStream(location));
            } catch (IOException e) {
                return null;
            }
        }
        //return message
        try {
            TestMessage testMessage = (TestMessage) in.readObject();
            in.close();
            return testMessage.getMessage();
         } catch (IOException | ClassNotFoundException e) {
            return null;
        }
    }

    public static void main(String args[]) {
        System.out.println(readMessage("https://www.cl.cam.ac.uk/teaching/current/FJava/testmessage-msr45.jobj"));
    }
}
