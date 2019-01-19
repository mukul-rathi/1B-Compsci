
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netinet/in.h>


int main(int argc, char *argv[]) {
  FILE *fp;
  FILE *fp2;
  
  if (argc != 3) {
    puts("Usage: <src file> <extract file>");
    return 1;
  }

  if ((fp=fopen(argv[1],"rb")) == 0) {
    perror("Cannot find file to serve");
    return 2;
  }
  fp2=fopen(argv[2],"wb");
  struct ipheader{
    unsigned int headerLength : 4;
    uint16_t total_length;
  } ip1;

  struct tcpheader{
    unsigned int dataOffset : 4;
  } tcp1;
    fseek(fp,0,SEEK_SET);
    fseek(fp2,0,SEEK_SET);

    fseek(fp, 0, SEEK_END);
    long int fileSize = ftell(fp); 
    fseek(fp,0,SEEK_SET);

    long int offset = 0;
    
    while(offset<fileSize) {
      fseek(fp,offset,SEEK_SET);
      uint8_t headerLen[2];
      fread(&headerLen,sizeof(char),2,fp);
      ip1.headerLength = headerLen[0] & (uint8_t) 7; // get lower 4 bits
      uint16_t totalLen;
      fread(&totalLen, sizeof(uint16_t),1,fp); 
      ip1.total_length = ntohs(totalLen);
      fseek(fp,offset + 4*ip1.headerLength,SEEK_SET);
      //seek to end of ip header

      uint8_t temp[20];
      fread(&temp,sizeof(char),20,fp);

      tcp1.dataOffset = temp[12] >> 4;
      fseek(fp,offset + 4*(ip1.headerLength + tcp1.dataOffset),SEEK_SET);

      int dataLength = ip1.total_length-4*(ip1.headerLength + tcp1.dataOffset);
      uint8_t data[dataLength];
      fread(&data,sizeof(char),dataLength,fp);

      fwrite(data, 1, dataLength, fp2);
      offset+=ip1.total_length;
    }
  


}
