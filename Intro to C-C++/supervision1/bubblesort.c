#include<stdio.h>

void bubbleSort(int* arr, int len){
	int sorted = 0;
	while(!sorted){ 		
		//make a pass through array to check if any swaps were made
		sorted = 1;	    
		int temp = 0;
		for(int i=0; i<len-1; i++){
			if (arr[i]>arr[i+1]){
				temp=arr[i];
				arr[i] = arr[i+1];
				arr[i+1] = temp;
				sorted = 0; 
			//  if the adjacent elements not in order, swap them and note that the array isn't sorted (set sorted to 0)
			}
		}
	}
			
}

int main(void){
	//could easily write code to input the array provided by the user but 
	//kept it simple with hard-coded example.
	int len = 10;
	int i[] = { 48, 23, 100, 84, 9, 29, 23, 71, 329, -122};
	printf("UNSORTED: \n");	
	for(int j=0; j<len; j++) printf("%d , ", i[j]);
	printf("\n");
	
	bubbleSort(i,len);

	printf("SORTED: \n");
	for(int j=0; j<len; j++) printf("%d , ", i[j]);
	printf("\n");
	return 0;

}
