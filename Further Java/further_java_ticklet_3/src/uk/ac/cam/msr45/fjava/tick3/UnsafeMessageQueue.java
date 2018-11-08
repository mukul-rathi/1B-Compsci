package uk.ac.cam.msr45.fjava.tick3;

public class UnsafeMessageQueue<T> implements MessageQueue<T> {
    private static class Link<L> {
	L val;
	Link<L> next;
	Link(L val) { 
	    this.val = val; 
	    this.next = null; 
	}
    }
    private Link<T> first = null;
    private Link<T> last = null;

    public void put(T val) {

		Link<T> newNode = new Link<T>(val);
		//empty list
		if(null == first){
			first = last = newNode;
		}
		else{ //append to end of list
			last.next = newNode;
			last = newNode;
		}
    }

    public T take() {
	while(first == null) { //use a loop to block thread until data is available
	    try {
		Thread.sleep(100);
	    } catch(InterruptedException ie) {
		// Ignored exception
		//exception thrown if thread sleeping/waiting/blocked and
			// woken up by another thread
			//you should clean up any activity if interrupted
			// (sleep requires no cleanup), could also propagate the interruptedexception to the caller
			//can re-interrupt the current thread using Thread.currentThread().interrupt();

	    }
	}
		if(last==first){ //one element in list
			last = null;
		}
		T val = first.val;
		first = first.next;
	return val;
    }
}