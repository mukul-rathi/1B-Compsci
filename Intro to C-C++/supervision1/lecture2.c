#include <stdio.h>
#include <string.h>

int cntlower(char str[], unsigned int len){
	int count=0;
	for(int i=0; i<len; i++){
		count += (str[i]>='a' && str[i]<='z');
	}
	return count;
}

void mergeSort(int i[], int len){
	if(len>1){
		//recursively merge the two halves
		mergeSort(i, len/2);
		mergeSort(i+len/2, len-len/2);
		int left[len/2];
		for(int j=0; j<len/2; j++){
			left[j] = i[j];
		}
		//merge the arrays (we only need n/2 space)
		int *right = i+len/2;
		int leftCounter = 0;
		int rightCounter =0;
		while(leftCounter<len/2 && rightCounter<(len-len/2)){
			if(*(left+leftCounter) < *(right+rightCounter)){
				*i = *(left+leftCounter);
				i++, leftCounter++;
			
			}
			else{
				*i = *(right+rightCounter);
				i++, rightCounter++;
			}
		}
		while(leftCounter<len/2){
		//copy over remaining items
			*i = *(left+leftCounter);
			i++, leftCounter++;
		}
	}
}

int main(void){
	char s[] = "Hello World!";
	printf("Count: %d\n", cntlower(s, strlen(s)));

	int i[] = {32,0,32,28943,74983,-91,89,21,3782,92};
	int len = 10;
	printf("UNSORTED: ");
	for(int j=0; j<len; j++) printf("%d ,", i[j]);	
	
	printf("\n");
	mergeSort(i, len);
	
	printf("SORTED: ");
	for(int j=0; j<len; j++) printf("%d ,", i[j]);	
	printf("\n");
	return 0;
}
