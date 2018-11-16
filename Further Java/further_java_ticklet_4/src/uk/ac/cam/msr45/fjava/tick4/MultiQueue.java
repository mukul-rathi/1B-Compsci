package uk.ac.cam.msr45.fjava.tick4;

import java.util.HashSet;
import java.util.Set;

public class MultiQueue<T> {
    private Set<MessageQueue<T>> outputs = new HashSet<MessageQueue<T>>();

    public synchronized void register(MessageQueue<T> q) {
        outputs.add(q);
    }

    public synchronized void deregister(MessageQueue<T> q) {
        outputs.remove(q);
    }

    public synchronized void put(T message) {
        for(MessageQueue<T> q : outputs){
            q.put(message);
        }
    }
}