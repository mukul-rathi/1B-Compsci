package uk.ac.cam.msr45.fjava.tick3;

public class QueueTest {

    private class Producer extends Thread {
	private int sent = 0;
	public void run() {
		//put the string "0", "1", "2" ..."50000" into the message queue
	    for (int i = 0; i < 50000; ++i) {
		q.put("" + i);
		sent++; //keep track of num produced
	    }
	}
	public int numberProduced() {return sent;}
    }

    private class Consumer extends Thread {
	private int recv = 0; //keep track of num received
	public void run() {
	    while (!q.take().equals("EOF")) {
	    	//whilst we haven't reached EOF keep consuming
		recv++;
	    }
	    q.put("EOF"); //we've removed EOF from queue - put it back
	}
	public int numberConsumed() {return recv;}
    }

    private MessageQueue<String> q;
    private Consumer[] consumers;
    private Producer[] producers;

    QueueTest(MessageQueue<String> q, int c, int p) {
	this.q = q;
	consumers = new Consumer[c];
	for (int i = 0; i < c; ++i) {
	    consumers[i] = new Consumer();
	}
	producers = new Producer[p];
	for (int i = 0; i < p; ++i) {
	    producers[i] = new Producer();
	}
    }

    public void run() {
	//start each consumer and producer in separate threads
	for (Consumer c : consumers) {
	    c.start();
	}
		
	for (Producer p : producers) {
	    p.start();
	}
		
	for (Producer p : producers) {
	    try {
			//this QueueTest thread waits until p has died
			p.join();
	    } catch (InterruptedException e) {
		// IGNORE exception
	    }
	}
	q.put("EOF"); //reached end of file
		// (no more producers adding to queue)
	//terminate join at 10 secs since EOF marker may get lost
	for (Consumer c : consumers) { 
	    try {
	    	//this QueueTest thread waits until c has died or timeout
		c.join(10000);
	    } catch (InterruptedException e) {
		// IGNORE exception
	    }
	}

	int recv = 0;

	for (Consumer consumer : consumers) { 
	    recv += consumer.numberConsumed(); 
	}
	int sent = 0;
	for (Producer p : producers) { 
	    sent += p.numberProduced(); 
	}
	//print total number received / sent across all threads
	System.out.println(recv + " / " + sent);
    }

    public static void main(String[] args) {
	System.out.println("** UNSAFE ** ");
	new QueueTest(new UnsafeMessageQueue<String>(), 1, 1).run();
	new QueueTest(new UnsafeMessageQueue<String>(), 3, 1).run();
	new QueueTest(new UnsafeMessageQueue<String>(), 1, 3).run();
	new QueueTest(new UnsafeMessageQueue<String>(), 3, 3).run();
	
	System.out.println("** SAFE ** ");
	new QueueTest(new SafeMessageQueue<String>(), 1, 1).run();
	new QueueTest(new SafeMessageQueue<String>(), 3, 1).run();
	new QueueTest(new SafeMessageQueue<String>(), 1, 3).run();
	new QueueTest(new SafeMessageQueue<String>(), 3, 3).run();
    }
}
