
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>


int main(int argc, char *argv[]) {
  FILE *fp;
  
  if (argc != 2) {
    puts("Usage: <file>");
    return 1;
  }

  if ((fp=fopen(argv[1],"rb")) == 0) {
    perror("Cannot find file to serve");
    return 2;
  }
  struct ipheader{
    unsigned int headerLength : 4;
    uint16_t total_length;
    uint8_t source_addr[4];
    uint8_t dest_addr[4];
  } ip1;

  struct tcpheader{
    unsigned int dataOffset : 4;
  } tcp1;

    //read ip header
    uint8_t temp[20];

    fseek(fp,0,SEEK_SET);
    fread(&temp,sizeof(char),20,fp);
    ip1.headerLength = temp[0] & (uint8_t) 7; // get lower 4 bits
    ip1.total_length = (temp[2] <<4) + temp[3];
    for(int i=0; i<4; i++){
       ip1.source_addr[i] = temp[i+12];
       ip1.dest_addr[i] = temp[i+16];
    }
    fseek(fp, 4*(ip1.headerLength-5), SEEK_CUR); //seek to end of ip header

    fseek(fp, 12,SEEK_CUR);

    uint8_t temp2; 
    fread(&temp2,sizeof(char),1,fp);
    tcp1.dataOffset = temp2 >> 4;
    
    int numPackets = 0;
    fseek(fp,0,SEEK_SET);

    while(!feof(fp)) {
      uint8_t temp3[4];
      fread(&temp3,sizeof(char),4,fp);
      int length = (temp3[2]<<4) + temp3[3];
      uint8_t temp4;
      for(int i=0; i<(length-4); i++){
         fread(&temp4,sizeof(char),1,fp);
      } 
      numPackets++;
    }



    // print to stdout
    for(int i=0; i<4; i++){
      printf("%d", (int) ip1.source_addr[i]);
      if(i!=3){
        printf(".");
      }
      else{
        printf(" ");
      }
    }
    for(int i=0; i<4; i++){
      printf("%d", (int) ip1.dest_addr[i]);
      if(i!=3){
        printf(".");
      }
      else{
        printf(" ");
      }
    }

    printf("%d ",  ip1.headerLength);
    
    printf("%d ", ip1.total_length);

    printf("%d ", tcp1.dataOffset);
    
    printf("%d\n", numPackets);


}
