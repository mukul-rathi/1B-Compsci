package uk.ac.cam.msr45.fjava.tick1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;

public class StringChat {
    public static void main(String[] args) {

		String server = null;
		int port = 0;
		try {
			server = args[0];
			port = Integer.parseInt(args[1]);
		} catch (ArrayIndexOutOfBoundsException | NumberFormatException e) {
			System.err.println("This application requires two arguments: <machine> <port>");
			return;
		}
		// s is declared final because we want to ensure we remain connected to the same Socket
		//not switching to a different socket - final prevents reassignment
		// also final is thread-safe
		// also for older versions of Java for an anonymous class to access a reference the reference needs to be final
		try {
			final Socket s = new Socket(server, port);

			Thread output = new Thread() {
				@Override
				public void run() {
					BufferedReader in = null;
					try {
						in = new BufferedReader(new InputStreamReader(s.getInputStream()));

						while (true) {
							System.out.println(in.readLine());
						}
					} catch (IOException e) {
						e.getStackTrace();
					}
				}
			};

			output.setDaemon(true); //this is a daemon thread - JVM exits when user threads finish even if daemon threads are still running - i.e. it'll be abandoned when main program done. 
			output.start();

			BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));
			OutputStream out = s.getOutputStream();
			while (true)
			{
				// read data from the user, blocking until ready. Convert the
				//      string data from the user into an array of bytes and write
				//      the array of bytes to "socket".
				//
				//userInput.readLine()  call blocks until a user has written a complete line of text
				//      and presses the enter key.
				out.write(userInput.readLine().getBytes());

			}
		} catch (IOException e) {
			System.err.println("Cannot connect to " + server + " on port " + port);
			return;
		}
	}
}
