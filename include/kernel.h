#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>
#include "qosclib.h"
#include "idt.h"

void screen_startup(void);

void kernel_main(void);

#endif
