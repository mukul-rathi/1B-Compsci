package uk.ac.cam.msr45.fjava.tick4;

import uk.ac.cam.cl.fjava.messages.Message;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class ChatServer {
    public static void main(String args[]) {
	    if(args.length!=1){
            System.err.println("Usage: java ChatServer <port>\n");
            return;
        }
        int port;
        try {
             port = Integer.parseInt(args[0]);
        }
        catch(NumberFormatException e){
            System.err.println("Usage: java ChatServer <port>\n");
            return;
        }
        ServerSocket server = null;
        try {
             server = new ServerSocket(port);
        } catch (IOException e) {
            System.err.println("Cannot use port number " + port + "\n");
            return;
        }
            MultiQueue<Message> multiQueue = new MultiQueue<Message>();

            while(true){
                Socket sckt = null;
                try {
                     sckt = server.accept();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                ClientHandler c = new ClientHandler(sckt,multiQueue);
            }
    }
}