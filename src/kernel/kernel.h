#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>
#include "vgam3.h"
#include "isr/idt.h"
#include "io_routines/io_r.h"

void screen_startup(void);

void kernel_main(void);

#endif
