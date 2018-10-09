import uk.ac.cam.msr45.fjava.tick0.ExternalSort;

import java.io.*;
import java.util.concurrent.ThreadLocalRandom;

public class Test {

    //debug sorting algorithm's output
    private static void printNumbers(String f1) throws IOException {
        DataInputStream in = readFile(f1,f1,true);
        System.out.println("\nThe numbers in " + f1 + " are :");
        int i=0;
        while(i<20 && in.available()>=4){ //print first 20 numbers
            int val = in.readInt();
            System.out.print(val + " ");

            i++;

        }
    }

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
                    new BufferedOutputStream(new FileOutputStream(new RandomAccessFile(f1,"rw").getFD())));
        }
        else{
            return new DataOutputStream(
                    new BufferedOutputStream(new FileOutputStream(new RandomAccessFile(f2,"rw").getFD())));
        }
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
    private static void createRandomFile(String f1, int length) throws IOException {
        DataOutputStream x = writeFile(f1, f1, true);
        for(int i=0; i<length; i++) {
            x.writeInt(ThreadLocalRandom.current().nextInt(0, 100 + 1));
        }
        x.flush();
        x.close();
    }
    public static void main(String[] args) throws IOException {
        String f1 = "test.dat";
        String f2 = "test2.dat";
        createRandomFile(f1,20);
        createRandomFile(f2,20);

        System.out.println("File Length: " + (new RandomAccessFile(f1, "r").length()));


        System.out.println("UNSORTED:  ");
        ExternalSort.printNumbers(f1);
        ExternalSort.sort(f1, f2);
        System.out.println("\nSORTED:  ");
        ExternalSort.printNumbers(f1);
    }
}
