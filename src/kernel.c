#include "kernel.h"

void kernel_main(void){
    char *vram = (char*)0xb8000;
    vram[0] = 'A'; 
    vram[1] = 1;
}

