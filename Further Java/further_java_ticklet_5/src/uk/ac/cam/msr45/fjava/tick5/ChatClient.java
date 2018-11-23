package uk.ac.cam.msr45.fjava.tick5;


import uk.ac.cam.cl.fjava.messages.*;

import java.io.*;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.Socket;
import java.text.FieldPosition;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;


public class ChatClient {
    private final VectorClock vectorClock;
    private ReorderBuffer messagesIn;
    private final String uid;

    public ChatClient(){
        vectorClock = new VectorClock();
        uid = UUID.randomUUID().toString();

    }
    private static String currentTime() {
        SimpleDateFormat s = new SimpleDateFormat("HH:mm:ss");
        StringBuffer format = s.format(new Date(), new StringBuffer(),new FieldPosition(0));
        //new date creates Date object with current time
        return format.toString();

    }

    private static String printMessageTime(Message m) {
        SimpleDateFormat s = new SimpleDateFormat("HH:mm:ss");
        StringBuffer format = s.format(m.getCreationTime(), new StringBuffer(),new FieldPosition(0));
        return format.toString();
    }
    public static void main(String[] args) {
        ChatClient c = new ChatClient();
        c.runClient(args);
    }

    public void runClient(String[] args){
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
                           Message m1 = ((Message) in.readObject());
                           vectorClock.updateClock(m1.getVectorClock());
                           //DOESN'T WORK FOR 15004 SINCE GET VECTOR CLOCK = NULL
                            //SO UPDATE CLOCK HAS NULL POINTER EXCEPTION
                           if(messagesIn==null){ //first message
                               messagesIn = new ReorderBuffer(m1.getVectorClock());
                           }
                           messagesIn.addMessage(m1);
                            for(Message message: messagesIn.pop())
                            //conditional printing
                            if(message instanceof StatusMessage){
                                System.out.println(printMessageTime(message) + " [Server] " + ((StatusMessage) message).getMessage());
                            }
                            else if(message instanceof RelayMessage){
                                System.out.println(printMessageTime(message) + " ["+((RelayMessage) message).getFrom()+ "] " + ((RelayMessage) message).getMessage());
                            }
                            else if(message instanceof NewMessageType){
                                System.out.println( printMessageTime(message) + " [Client] New class " + ((NewMessageType) message).getName() + " loaded." );
                                in.addClass(((NewMessageType) message).getName(), ((NewMessageType) message).getClassData());
                            }
                            else{
                                System.out.print(printMessageTime(message)+ " [Client] " + message.getClass().getSimpleName()+ ": ");
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
                        out.writeObject(new ChangeNickMessage(userInput.split(" ")[1], uid, vectorClock.incrementClock(uid)));
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
                    out.writeObject(new ChatMessage(userInput,uid, vectorClock.incrementClock(uid)));
                }


            }
        } catch (IOException e) {
            System.err.println("Cannot connect to " + server + " on port " + port);
            return;
        }
    }
}


