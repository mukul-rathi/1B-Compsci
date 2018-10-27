#include <stdio.h>

int *G;

int f(void) { //f() is reliant on side effects of updating pointer G
  int l = 1;
  int res = *G; //if G hasn't been initialised and first run of f() then we have UNDEFINED behaviour
  G = &l;  //once we exit scope this address is no longer valid as popped off stack
  return res;
}

int main(void) {
  int x = 2;
  G = &x;
  f();
  printf("%d\n", f()); //this will print weird things 
}
