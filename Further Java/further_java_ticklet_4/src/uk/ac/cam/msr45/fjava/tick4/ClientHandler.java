package uk.ac.cam.msr45.fjava.tick4;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.text.FieldPosition;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import uk.ac.cam.cl.fjava.messages.*;

public class ClientHandler {
    private Socket socket;
    private MultiQueue<Message> multiQueue;
    private String nickname;
    private MessageQueue<Message> clientMessages;
    Thread incoming;
    Thread outgoing;
    Random r = new Random();

    public ClientHandler(Socket s, MultiQueue<Message> q) {
        socket = s;
        multiQueue = q;
        nickname = "Anonymous" + (10000 + r.nextInt(89999));
        clientMessages = new SafeMessageQueue<Message>();
        multiQueue.register(clientMessages);
        multiQueue.put(new StatusMessage(nickname + " connected from " + s.getInetAddress().getHostName()+ "."));


        //incoming messages from client
        incoming = new Thread() {
            @Override
            public void run() {
                ObjectInputStream in = null;
                try {
                    in = new ObjectInputStream(s.getInputStream());
                    while (true) {
                        Message message = (Message) in.readObject();
                        if (message instanceof ChangeNickMessage) {
                            multiQueue.put(new StatusMessage(nickname + " is now known as " + ((ChangeNickMessage) message).name+"."));
                            nickname = ((ChangeNickMessage) message).name;
                        }
                        if (message instanceof ChatMessage) {
                            multiQueue.put(new RelayMessage(nickname, (ChatMessage) message));
                        }
                    }
                } catch (IOException e) {
                    multiQueue.deregister(clientMessages);
                    multiQueue.put(new StatusMessage(nickname + " has disconnected."));
                    return;

                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
            }
        };

        //output messages to client
        outgoing = new Thread() {
            @Override
            public void run() {
                ObjectOutputStream out = null;
                try {
                    out = new ObjectOutputStream(s.getOutputStream());

                    while (true) {
                        out.writeObject(clientMessages.take());
                    }
                }
                catch (IOException e) {
                    return;
                }

            }

            


        };

        incoming.start();
        outgoing.start();
    }

}

