package uk.ac.cam.msr45.fjava.tick2;


import uk.ac.cam.cl.fjava.messages.*;

import java.io.*;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.Socket;
import java.net.UnknownHostException;
import java.text.FieldPosition;
import java.text.SimpleDateFormat;
import java.util.Date;

@FurtherJavaPreamble(
        author = "Mukul Rathi",
        date = "27th October 2018",
        crsid = "msr45",
        summary = "Chat Client for Tick 2 - communicates with server and prints out messages",
        ticker = FurtherJavaPreamble.Ticker.B)

public class ChatClient {
    private static String currentTime() {
        SimpleDateFormat s = new SimpleDateFormat("HH:mm:ss");
        StringBuffer format = s.format(new Date(), new StringBuffer(),new FieldPosition(0));
        //new date creates Date object with current time
        return format.toString();

    }

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
        // also for older versions of Java for anonymous classes to use a reference it needs to be final
        try {
            final Socket s = new Socket(server, port);
            System.out.println(currentTime() + " [Client] Connected to " +server + " on port " + port +".");
            Thread output = new Thread() {
                @Override
                public void run() {
                    DynamicObjectInputStream in = null;
                    try {
                        in = new DynamicObjectInputStream(s.getInputStream());

                        while (true) {
                            Message message = (Message) in.readObject();
                            if(message instanceof StatusMessage){
                                System.out.println(currentTime() + " [Server] " + ((StatusMessage) message).getMessage());
                            }
                            else if(message instanceof RelayMessage){
                                System.out.println(currentTime() + " ["+((RelayMessage) message).getFrom()+ "] " + ((RelayMessage) message).getMessage());
                            }
                            else if(message instanceof NewMessageType){
                                System.out.println( currentTime() + " [Client] New class " + ((NewMessageType) message).getName() + " loaded." );
                                in.addClass(((NewMessageType) message).getName(), ((NewMessageType) message).getClassData());
                            }
                            else{
                                System.out.print( currentTime() + " [Client] " + message.getClass().getSimpleName()+ ": ");
                                Field[] fields =  message.getClass().getDeclaredFields();
                                for(int i=0; i<fields.length ; i++){
                                    Field f =fields[i];
                                    f.setAccessible(true); //actually be able to access it
                                    if(i!=0){
                                        System.out.print(", ");
                                    }
                                    System.out.print(f.getName() + "(" + f.get(message) + ")");
                                }
                                System.out.print("\n");

                                for(Method m: message.getClass().getMethods()){
                                    if(m.getParameterCount()==0 && m.isAnnotationPresent(Execute.class)){
                                        m.invoke(message);
                                    }
                                }
                            }
                        }

                    } catch (IOException e) {
                       e.getStackTrace();
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    }
                }
            };

            output.setDaemon(true); //this is a daemon thread - JVM exits when user threads finish even if daemon threads are still running - i.e. it'll be abandoned when main program done.
            output.start();

            BufferedReader r = new BufferedReader(new InputStreamReader(System.in));
            ObjectOutputStream out = new ObjectOutputStream(s.getOutputStream());
            while (true) {
                String userInput = r.readLine();
                if (userInput.startsWith("\\")) {
                    if (userInput.startsWith("\\nick")) {
                        out.writeObject(new ChangeNickMessage(userInput.split(" ")[1]));
                        //this sets whatever is after "\nick " as the name e.g. "\nick Bob" -> Bob
                    } else if (userInput.startsWith("\\quit")) {
                        System.out.println( currentTime() + " [Client] Connection terminated.");
                        out.close();
                        break;
                    }
                    else{
                        System.out.println("Unknown command: " + userInput.split(" ")[0].substring(1));
                    }
                }
                else {
                    out.writeObject(new ChatMessage(userInput));
                }


            }
        } catch (IOException e) {
            System.err.println("Cannot connect to " + server + " on port " + port);
            return;
        }
    }
}


