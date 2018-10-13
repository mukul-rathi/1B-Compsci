#include<stdio.h>
#include<stdlib.h>

struct stackNode{
	int value;
	struct stackNode *parent;
};

typedef struct stackNode Stack; 

void   push(Stack **oldStack, int newVal){
	Stack *newNode = (Stack *) malloc(sizeof(Stack));
	newNode->value = newVal;
	if(oldStack==NULL){
		oldStack = &newNode; //initialise it
		newNode->parent = NULL;
	}
	else{
		newNode->parent = *oldStack;
	}
	*oldStack = newNode;
}

int pop(Stack **oldStack){
	int val = (*oldStack)->value;
	Stack *newStack = (*oldStack)->parent;
	free(*oldStack);
	*oldStack = newStack;
	return val;
}


int main(int argc, char *argv[]){
	Stack **st = (Stack **)malloc(sizeof(Stack *));
 	for(int i=1; i<argc; i++){
		char curr = *(argv[i]); 
		if(curr>='0' && curr<='9'){
			push(st, (int) (curr-'0'));		
		}
		else if(curr=='+'){
			int b = pop(st);
			int a = pop(st);
			push(st, a+b);
		}
		
		else if(curr=='*'){
			int b = pop(st);
			int a = pop(st);
			push(st, a*b);
		}
		
		else if(curr=='-'){
			int b = pop(st);
			int a = pop(st);
			push(st, a-b);
		}
		
		else if(curr=='/'){
			int b = pop(st);
			int a = pop(st);
			push(st, a/b);
		}
		
	}
	printf("The answer is : %d\n", pop(st));
	return 0;

}
