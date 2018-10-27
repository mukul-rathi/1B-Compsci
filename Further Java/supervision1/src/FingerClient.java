/*
This class implements the Finger protocol (RFC 742)
 */

import java.io.*;
import java.net.Socket;

public class FingerClient {

    public static void main(String[] args) throws BadInputException, IOException {
        if(args.length!=1){
            throw new BadInputException();
        }
        String user = args[0].split("@")[0];
        String domain = args[0].split("@")[1];

        Socket socket = new Socket(domain,79 );

        PrintWriter out = new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
        out.write(user+"<CRLF>");
        out.flush();
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        while(in.readLine()!=null){
            System.out.println(in.readLine());
        }

    }
}



