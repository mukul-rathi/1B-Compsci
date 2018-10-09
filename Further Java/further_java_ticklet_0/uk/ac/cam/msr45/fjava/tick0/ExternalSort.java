package uk.ac.cam.msr45.fjava.tick0;

import java.io.*;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ExternalSort {

    //helper functions to create DataInput/OutputStreams
    private static DataInputStream readFile(String f1, String f2, boolean writeToFile2) throws IOException {
        if(writeToFile2){
            return new DataInputStream(
                    new BufferedInputStream(new FileInputStream(new RandomAccessFile(f1,"r").getFD())));
        }
        else{
            return new DataInputStream(
                    new BufferedInputStream(new FileInputStream(new RandomAccessFile(f2,"r").getFD())));
        }
    }
    private static DataOutputStream writeFile(String f1, String f2, boolean writeToFile2) throws IOException {
        if(writeToFile2){
            return new DataOutputStream(
                    new BufferedOutputStream(new FileOutputStream(new RandomAccessFile(f2,"rw").getFD())));
        }
        else{
            return new DataOutputStream(
                    new BufferedOutputStream(new FileOutputStream(new RandomAccessFile(f1,"rw").getFD())));
        }
    }



    private static void copyAcross(DataInputStream inFile, DataOutputStream outFile, int chunkLen, int maxChunkLen) throws IOException {
        if(inFile.available()<chunkLen){
            throw new IOException("Chunk Len doesn't match: it is : " + chunkLen + " should be: " + inFile.available());
        }
        for(int i=4; i<=chunkLen;i+=4){
            int val = inFile.readInt();
            outFile.writeInt(val);


            if (i%maxChunkLen==0){
                outFile.flush();
            }
        }
        outFile.flush();
    }

    private static void mergeChunk(DataInputStream inFileOdd, int chunkLenOdd, DataInputStream inFileEven, int chunkLenEven, DataOutputStream outFile, int maxChunkLen) throws IOException {
        if(inFileOdd.available()<chunkLenOdd){
            throw new IOException("Chunk Len Odd doesn't match: it is : " + chunkLenOdd + " should be: " + inFileOdd.available());
        }
        if(inFileEven.available()<chunkLenEven){
            throw new IOException("Chunk Len Even doesn't match it is : " + chunkLenEven + " should be: " + inFileEven.available());
        }
        int leftPointer = inFileOdd.readInt();
        int rightPointer = inFileEven.readInt();
        int bytesToWrite = 0; //number of bytes in buffer that needs to be flushed
        //chunkLenOdd = number of ints in left chunk that still need to be written
        //ditto for chunkLenEven

        while(chunkLenEven>0 || chunkLenOdd>0) {
            if (leftPointer <= rightPointer) {
                outFile.writeInt(leftPointer);
                chunkLenOdd -= 4;
                if (chunkLenOdd > 0) {//make sure not at end of chunk
                    leftPointer = inFileOdd.readInt();
                }
                else{
                    leftPointer = Integer.MAX_VALUE;
                }
            } else {
                outFile.writeInt(rightPointer);
                chunkLenEven -= 4;
                if (chunkLenEven > 0) { //make sure not at end of chunk
                    rightPointer = inFileEven.readInt();
                }
                else{
                    rightPointer = Integer.MAX_VALUE;

                }
            }
            bytesToWrite += 4; //4 bytes for each int

             if (bytesToWrite==maxChunkLen){
                outFile.flush();
                bytesToWrite=0;
             }
        }

    }

    private static void mergePass(String f1, String f2, boolean writeToFile2, int chunkLen, long fileLength, int maxChunkSize) throws IOException {
        //two iterators to iterate through alternate chunks for the merge
        DataInputStream inFileOdd = readFile(f1, f2, writeToFile2);
        DataInputStream inFileEven= readFile(f1,f2,writeToFile2);
        inFileEven.skipBytes(chunkLen); //start at second chunk
        int oddPos = inFileOdd.available();
        int evenPos = inFileEven.available();
        DataOutputStream outFile = writeFile(f1, f2, writeToFile2);

        
        //go through and merge pairs of chunk
        long maxNumChunks = Math.floorDiv(fileLength,chunkLen);
        for(int numChunks = 0; numChunks<=maxNumChunks;numChunks+=2){
            if(numChunks>0){
                inFileOdd.skipBytes(chunkLen); //move left chunk onto first chunk of next pair
                oddPos = inFileOdd.available();

                //check if last chunk (odd)
                if((numChunks+1)*chunkLen>=fileLength){
                    copyAcross(inFileOdd, outFile, (int) (fileLength-numChunks*chunkLen),maxChunkSize);
                    break;
                }
                else{ //we have another pair of chunks
                    inFileEven.skipBytes(chunkLen); //move right chunk onto right chunk of next pair
                    evenPos = inFileEven.available();
                }
            }

            int rightChunkLen = (int) Math.min(chunkLen, fileLength-(numChunks+1)*chunkLen); //see if right chunk is a full chunk or partial

            if(chunkLen> inFileOdd.available()){
                throw new IOException("Not enough bytes remaining in left chunk: " + inFileOdd.available());
            }
            if(rightChunkLen> inFileEven.available()){ //no right chunk
                throw new IOException("Not enough bytes remaining in right chunk: " + inFileEven.available());
            }
            mergeChunk(inFileOdd, chunkLen, inFileEven, rightChunkLen, outFile, maxChunkSize);


        }
        inFileOdd.close();
        inFileEven.close();
        outFile.close();

    }
    private static void quickSortChunks(int maxArrSize,String f1, String f2, int maxChunkSize, int fileLength) throws IOException {
        //write from f1 to f2
        DataInputStream inFile = readFile(f1,f2,true);
        DataOutputStream outFile = writeFile(f1,f2,false); //write in place
        int[] quickSortArr = new int[maxArrSize];
        long maxNumChunks = Math.floorDiv(fileLength,maxChunkSize);
        for (int numChunks = 0; numChunks < maxNumChunks; numChunks++) {

            //read in the data
            if (fileLength < (long) (numChunks + 1) * maxChunkSize) {
                //end chunk is a bit smaller since f1 doesn't divide exactly
                quickSortArr = new int[(fileLength - numChunks * maxChunkSize) / 4]; //get number of remaining bytes
                // and divide by 4 to get number of ints remaining
            }
            for (int i = 0; i < quickSortArr.length; i++) {
                int val =  inFile.readInt();
                quickSortArr[i] = val;
            }

            //sort in-Place
            QuickSort.sort(quickSortArr);
            //write the data out to buffer
            for (int i=0; i<quickSortArr.length;i++) {
                outFile.writeInt(quickSortArr[i]);

               // outFile.flush(); //write from buffer to disk
            }
            outFile.flush(); //write from buffer to disk


        }
        inFile.close();
        outFile.close();

    }


    public static void sort(String f1, String f2) throws FileNotFoundException, IOException {

		long fileLength = new RandomAccessFile(f1,"rw").length(); //store as variable so easy to view in debugger

        if(fileLength==0 || fileLength==4){ //already sorted (4 bytes == 1 int)
            return;
        }


		//find out how much memory is available
		Runtime runtime = Runtime.getRuntime();
		int maxChunkSize = (int) Math.min(fileLength, 3*runtime.freeMemory()/4); //if file fits in memory then allocate that much
        //otherwise assign half the free memory

        
        maxChunkSize = Math.min(maxChunkSize,4000000);

        int maxArrSize  = maxChunkSize/4; //4 bytes per int (max chunk that will fit in memory)

        // initially sort as much as possible in place using quicksort

        //sort chunks in place using quicksort - these are leaves for the external merge sort

        //find max chunk size
        quickSortChunks(maxArrSize,f1,f2,maxChunkSize, (int) fileLength);

        if(fileLength==maxChunkSize){
            return; //sorted already by quicksort
        }

		boolean writeToFile2 = true; //write to file 2


        //initially chunk length = maxChunkSize , then doubles each
		//pass of merging

        for(int chunkLen=maxChunkSize; chunkLen<fileLength;chunkLen*=2){
            //assuming implicitly that less than 2^32 bytes i.e less than ~4GB files, since chunkSize stored in an int
            if(chunkLen!=maxChunkSize) { //i.e not on first pass
                writeToFile2 = !writeToFile2; //write to other file next pass

            }
            mergePass(f1,f2,writeToFile2,chunkLen, fileLength, maxChunkSize);
		}

		//check if need to copy back to file A
        if(writeToFile2){
            DataInputStream fileB = readFile(f1, f2, false);
            DataOutputStream fileA = writeFile(f1, f2, false);
            copyAcross(fileB,fileA, (int) fileLength,maxChunkSize);
            fileB.close();
            fileA.close();
        }
	}



    private static String byteToHex(byte b) {
		String r = Integer.toHexString(b);
		if (r.length() == 8) {
			return r.substring(6);
		}
		return r;
	}

	public static String checkSum(String f) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			DigestInputStream ds = new DigestInputStream(
					new FileInputStream(f), md);
			byte[] b = new byte[512];
			while (ds.read(b) != -1)
				;

			String computed = "";
			for(byte v : md.digest())
				computed += byteToHex(v);

			return computed;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "<error computing checksum>";
	}

    //debug sorting algorithm's output
    public static void printNumbers(String f1) throws IOException {
        DataInputStream in = readFile(f1,f1,true);
        System.out.println("\nThe numbers in " + f1 + " are :");
        int i=0;
        while(i<20 && in.available()>=4){ //print first 20 numbers
            int val = in.readInt();
            System.out.print(val + " ");

            i++;

        }
    }

    private static void printSorted(String f1) throws IOException {
        DataInputStream in = readFile(f1,f1,true);
        int i=0;
        int prev;
        int curr = Integer.MIN_VALUE;
        boolean sorted = true;
        while(in.available()>=4){
            prev = curr;
            curr = in.readInt();
            if(prev>curr){
                sorted = false;
            }

        }
        System.out.println("\nAre the numbers in " + f1 + " sorted? " + sorted);
    }

	public static void main(String[] args) throws Exception {
        for(int i=4; i<=17; i++) {
            String f1 = "../test-suite/test" + i + "a.dat";
            String f2 = "../test-suite/test" + i + "b.dat";
            sort(f1, f2);

            System.out.println("\nChecksum is: " + checkSum(f1));


        }
	}

}
//