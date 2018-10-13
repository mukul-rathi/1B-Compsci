#include<stdio.h>
#include<stdlib.h>

struct stackNode{
	int value;
	struct stackNode *parent;
};

typedef struct stackNode Stack; 

Stack *push(Stack *oldStack, int newVal){
	Stack *newNode = (Stack *) malloc(sizeof(Stack));
	newNode->value = newVal;
	newNode->parent = oldStack;
	return newNode;
}

int pop(Stack *oldStack){
	int val = oldStack->value;
	Stack *newStack = oldStack->parent;
	free(oldStack);
	*oldStack = *newStack;
	return val;
}


int main(int argc, char *argv[]){
	Stack *st = NULL;
 	for(int i=1; i<argc; i++){
		char curr = *(argv[i]); 
		if(curr>='0' && curr<='9'){
			st = push(st, (int) (curr-'0'));		
		}
		else if(curr=='+'){
			int b = pop(st);
			int a = pop(st);
			st = push(st, a+b);
		}
		
		else if(curr=='*'){
			int b = pop(st);
			int a = pop(st);
			st = push(st, a*b);
		}
		
		else if(curr=='-'){
			int b = pop(st);
			int a = pop(st);
			st = push(st, a-b);
		}
		
		else if(curr=='/'){
			int b = pop(st);
			int a = pop(st);
			st = push(st, a/b);
		}
		
	}
	if(st!=NULL){
		printf("The answer is : %d\n", st->value);
	}
	return 0;

}
