package uk.ac.cam.msr45.fjava.tick5;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import uk.ac.cam.cl.fjava.messages.Message;
import uk.ac.cam.msr45.fjava.tick5.VectorClock;

public class ReorderBuffer {

    private final List<Message> buffer;
    private final VectorClock lastDisplayed;

    public void addMessage(Message m) {
        if (!(new VectorClock(m.getVectorClock()).happenedBefore(lastDisplayed))) {
            //ignore message if it happened before last displayed message
            buffer.add(m);
        }
    }

    public ReorderBuffer(Map<String, Integer> initialMsg) {
        buffer = new ArrayList<Message>();
        lastDisplayed = new VectorClock(initialMsg);
    }

    public Collection<Message> pop() {
        ArrayList<Message> eligMessages = new ArrayList<Message>();
        int i=0;
        while(i<buffer.size()) {
            Message m = buffer.get(i);
            //check if eligible
            boolean eligible = true;
            boolean seenOneMore = false;
            for (String uid : m.getVectorClock().keySet()) {
                if (m.getVectorClock().get(uid) > lastDisplayed.getClock(uid) + 1) {
                    //definitely at least one message before this
                    //(with clock =lastDisplayed.getClock(uid)+1)
                    eligible = false;
                    break;
                }
                else if (m.getVectorClock().get(uid) == lastDisplayed.getClock(uid) + 1) {
                    if (seenOneMore) {
                        eligible = false;
                        break;
                    } else {
                        seenOneMore = true;
                    }
                }
            }
            if(eligible){
                buffer.remove(m);
                lastDisplayed.updateClock(m.getVectorClock());
                eligMessages.add(m);
                 i=0; //start scanning at start again
            }
            else{
                i++;
            }
        }
        return eligMessages;

    }

}