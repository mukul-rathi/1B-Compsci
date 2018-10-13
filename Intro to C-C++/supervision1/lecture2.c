#include <stdio.h>
#include <string.h>

int cntlower(char str[], unsigned int len){
	int count=0;
	for(int i=0; i<len; i++){
		count += (str[i]>='a' && str[i]<='z');
	}
	return count;
}

int main(void){
	char s[] = "Hello World!";
	printf("Count: %d\n", cntlower(s, strlen(s)));
	return 0;

}
