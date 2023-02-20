[org 0x7c00]
_start:
    mov [BOOT_DISK], dl
    ;Load segmented registers
    mov ax, 0
    mov es, ax
    mov ds, ax
    mov bp, 0x1200
    mov sp, bp
    mov bx, 0x7e00

    mov ah, 2               
    mov al, 2               ;number of sectors
    mov ch, 0               ;Cylinder number
    mov cl, 2               ;Sector number
    mov dh, 0               ;Head number
    mov dl, [BOOT_DISK]
    int 0x13

_print_title:
    mov ah, 0
    int 0x16
    mov ah, 0x0e            ;teletype mode
    mov si, _title
    call _print_loop
    mov ah, 0
    int 0x16
    mov ah, 0x0e            ;teletype mode
    mov si, _markito
    call _print_loop
_print_loop:
    mov al, [si]
    int 0x10                ;call BIOS interrupt 0x10 for print
    inc si
    test al,al
    jne _print_loop
    ret

jmp $ 
BOOT_DISK: db 0
times 510-($-$$) db 0
db 0x55, 0xaa

_title:
    db "***** BLR-OPHON BOSTALOADER VERSION 1.0 *****", 0x0a, 0x0d, 0
_markito:
    db "        ####            ",0xa,0xd
    db "      ##########        ",0xa,0xd
    db "  ###################   ",0xa,0xd
    db "  ####################  ",0xa,0xd
    db " #####################  ",0xa,0xd
    db "##########  ##########  ",0xa,0xd
    db "#######       ########  ",0xa,0xd
    db "####             #####  ",0xa,0xd
    db " ##              #####  ",0xa,0xd
    db "  #               ####  ",0xa,0xd
    db "           ###########  ",0xa,0xd
    db "  #################    #",0xa,0xd
    db "  #####  ##########  # #",0xa,0xd
    db "  #####  #########    # ",0xa,0xd
    db "   ## #               # ",0xa,0xd
    db "     #                  ",0xa,0xd
    db "  #                     ",0xa,0xd
    db "  #                     ",0xa,0xd
    db "                #       ",0xa,0xd
    db "    # #####  ##      #  ",0xa,0xd
    db "      ##    ##          ",0xa,0xd
    db "      ######       #    ",0xa,0xd
    db "        ###             ",0xa,0xd 
    db "       #                ",0xa,0xd
    db "         #####          ",0xa,0xd,0
