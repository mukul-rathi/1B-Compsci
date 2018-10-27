/* Find different optimization levels which will change the
   behaviour of the program. */
void foo(int i) {
  foo(i+1);  //undefined once i == INT_MAX_VALUE - since signed int doesn't overflow.
	//also seg fault since stack space exceeds the virtual address space allocated by OS
	

	//with optimisations no seg fault as tail recursion used so stack doesn't overflow,
}


int main(void) { 
  foo(0);
  return 0;
}
