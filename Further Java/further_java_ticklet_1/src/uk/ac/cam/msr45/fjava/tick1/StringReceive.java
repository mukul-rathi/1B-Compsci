package uk.ac.cam.msr45.fjava.tick1;


import java.io.*;
import java.net.Socket;

public class StringReceive {


    public static void main(String[] args){
        String server = null;
        Integer port = null;
        try {
            server = args[0];
            port = Integer.parseInt(args[1]);
        }
        catch (ArrayIndexOutOfBoundsException | NumberFormatException e){
            System.err.println("This application requires two arguments: <machine> <port>");
            return;
        }

        try {
            Socket sckt = new Socket(server,port);
            BufferedReader in = new BufferedReader(new InputStreamReader(sckt.getInputStream()));
            while(true){
                System.out.println(in.readLine());
            }
        } catch (IOException e) {
            System.err.println("Cannot connect to " + server+ " on port " + port);
            return;
        }


    }
}
