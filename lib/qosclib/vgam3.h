#ifndef VGAM3_H
#define VGAM3_H

#define VGA_MODE3_W 80
#define VGA_MODE3_H 25
#define MAIN_M3_COLOR 0x0a

#include <stdint.h>

void vgam3_clear(uint8_t color);

void vgam3_write(char *c, int x, int y, uint8_t color);

void vgam3_print(char *c, uint8_t color);

#endif
