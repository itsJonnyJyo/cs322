#include <stdio.h>
#include <stdlib.h>

extern void Xmain(void);
extern void XinitGlobals(void);

int main(int argc, char** argv) {
    XinitGlobals();
    Xmain();
    exit(0);
    return 0;
}

void Xprint(int val) {
    printf("output: %d\n", val);
}
//num == #elements  size == memory occupied by desired datatype
void* XallocArray(int num, int size) {
    //check if null
  if(size < 0){
    fprintf(stderr, "Invalid argument for size of memory block\n");
    exit(1);
  }
                            // 2-1 size+1; make room for 'length' elem
  int * addr = malloc(num * (size+1));
  if (NULL == addr) {
  fprintf(stderr, "Out of memory, malloc failed\n");
  exit(1);
  }
    
  return (void*)addr;
}
