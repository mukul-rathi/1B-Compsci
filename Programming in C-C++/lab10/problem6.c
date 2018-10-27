#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

typedef struct {
  int a,b,c;
} st;

int main(void) { 
  st obj = {10,12,15};
  st *p1 = &obj;
  st *p2 = NULL;
  intptr_t n = (intptr_t) &p2->b; // why doesn't this trigger a segmentation fault?
	//This has no seg fault because p2 is initialised (to NULL value on stack).
	// &p2->b = &((*p2).b) - *p2 is NULL so it's b field is undefined, we then get the address
	//of this undefined value and cast it to an int_ptr
	//int_ptr is a type that stores the address of an int.
  printf("%ld\n", *(intptr_t *) ((char*)p1 + n));//we cast (char*) so our pointer arithmetic incrments by n bytes
//we then get the value of the address 
  return 0;
}
