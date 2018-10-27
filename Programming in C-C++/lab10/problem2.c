#include <stdio.h>

void foo(int i) { 
  while (i) {        //INFINITE loop for i!=0
    /* loop? */
   }
}

int main(void) { 
  foo(1); 
  printf("Done!?\n"); //this is printed when compiler optimises, since compiler sees no 
	//instructions executed in infinite loop, but with no optimisations we are stuck.
  return 0;
}
