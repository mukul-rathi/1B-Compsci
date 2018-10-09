#include <ctype.h>
#include <string.h>
#include "revwords.h"

void reverse_substring(char str[], int start, int end) { 
  char temp;
  for(int i=0; i<=(end-start)/2; i++){
    temp = str[start+i];
    str[start+i] = str[end-i];
    str[end-i] = temp;
  }
}


int find_next_start(char str[], int len, int i) { 
  for(int j=i; j<len; j++){
    if(isalpha(str[j])){
      return j;
    }
  }
  return -1;
}

int find_next_end(char str[], int len, int i) {
   for(int j=i+1; j<len; j++){
    if(!isalpha(str[j])){
      return j;
    }
  }
  return len;
}

void reverse_words(char s[]) { 
  /* TODO */
  int len = strlen(s);
  int i =find_next_start(s,len, 0);
  while(i!=-1){
    reverse_substring(s, i, find_next_end(s,len, i)-1);
    i = find_next_start(s, len, find_next_end(s,len,i));
  }


}
