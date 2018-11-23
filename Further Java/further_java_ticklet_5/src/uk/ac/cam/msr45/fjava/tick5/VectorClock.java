package uk.ac.cam.msr45.fjava.tick5;

import java.util.HashMap;
import java.util.Map;

public class VectorClock {

    private final Map<String, Integer> vectorClock;

    public VectorClock() {
        vectorClock = new HashMap<>();
    }

    public VectorClock(Map<String, Integer> existingClock) {
        if(existingClock==null){
            vectorClock= new HashMap<>();
        }
        else {
            vectorClock = new HashMap<>(existingClock);
        }
    }

    public synchronized void updateClock(Map<String,Integer> msgClock) {
        if(msgClock==null) return;
        for(String s: msgClock.keySet()){
            if(msgClock.get(s)>=getClock(s)){
                    vectorClock.put(s,msgClock.get(s));
                }
        }
    }

    public synchronized Map<String,Integer> incrementClock(String uid) {
        vectorClock.put(uid, getClock(uid)+1);
        return vectorClock;
	//  this is required for thread safety so that when we package up the
        //message to be sent to the server we return the most up-to-date
        // clock - no other thread can modify it in between.

   }

    public synchronized int getClock(String uid) {
        if(vectorClock.containsKey(uid)){
            return vectorClock.get(uid);
        }
        else{
            return 0;
        }
    }

    public synchronized boolean happenedBefore(Map<String,Integer> other) {

        boolean hapBefore = false;
        for(String s : other.keySet()){
             if(getClock(s)>other.get(s)){
                return false; //happened after
            }
            else if(getClock(s)<other.get(s)){
                hapBefore = true;
            }
        }
        for(String s : vectorClock.keySet()){
            if(!other.containsKey(s) && vectorClock.get(s)>0) return false;
        }
        //at this step all elements are <= other
        return hapBefore; //false if no elements < other, true if at least one <
    }

    public synchronized boolean happenedBefore(VectorClock other) {

        return happenedBefore(other.vectorClock);
    }


}