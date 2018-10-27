int main(void) { 
  int i = 1;
  while (i > 0){ //i>0 is undefined once i overflows - may evaluate true/false depending on compiler
    i *= 2; 
  }
  return 0;
}
