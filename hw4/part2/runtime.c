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
    // 2-b check num arg
  if(num < 0){
    printf("Invalid argument for number of elements\n");
    exit(1);
  }
                            // 2-a size+1; make room for 'length' elem
  int * addr = malloc((num+1) * size);
  // 2-b check malloc 
  if (NULL == addr) {
  printf("Out of memory, malloc failed\n");
  exit(1);
  }
  // array size as first element
  //load length into the first 4 bytes(int32)  
  *addr = num;

//  int *addr2 = addr++;
  return (void*)addr;
}
