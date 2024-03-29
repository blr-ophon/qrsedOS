ASM := nasm 
ASMFLAGS := -g
CC := i686-elf-gcc
CFLAGS := -Wall -Werror -O0 -nostdlib -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostartfiles -nodefaultlibs -Iinc

INCLUDES := -I./lib/qosclib -I./src/kernel 
HEADERS := $(shell find ./ -name '*.h')

SRC_DIR := ./src
BIN_DIR := ./bin
BUILD_DIR := ./build

OS_BIN := ${BIN_DIR}/os.bin

BOOT_SRC := ${SRC_DIR}/boot/boot.asm
BOOT_BIN := ${BIN_DIR}/boot/boot.bin

KERNEL_C := $(shell find $(SRC_DIR)/kernel -name '*.c')
KERNEL_ASM := $(shell find $(SRC_DIR)/kernel -name '*.asm')

KERNEL_ASM_O := $(KERNEL_ASM:$(SRC_DIR)/%.asm=$(BUILD_DIR)/%.asm.o)
KERNEL_O := $(KERNEL_C:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
KERNEL_MERGED := ${BUILD_DIR}/kernel_merged.o
KERNEL_BIN := ${BIN_DIR}/kernel.bin

#TODO: Turn qosclib int a static library and have a separate makefile
QLIB_C := $(shell find ./lib/qosclib -name '*.c')
QLIB_O := $(QLIB_C:%.c=%.o)
QOSCLIB_O := ./lib/qosclib/QOSCLIB.o


all: ${OS_BIN} 
	ctags -R

${OS_BIN}: ${BOOT_BIN} ${KERNEL_BIN}
	rm -rf $@
	dd if=${BOOT_BIN} >> ${OS_BIN}
	dd if=${KERNEL_BIN} >> ${OS_BIN}
	#16MB bytes of zeroes (file data region)
	dd if=/dev/zero bs=1048576 count=16 >> ${OS_BIN} 


####### Boot section #######
${BOOT_BIN}: ${BOOT_SRC}
	mkdir -p $(dir $@)
	${ASM} ${ASMFLAGS} -f bin $< -o $@

####### Kernel section #######
${KERNEL_BIN}: ${KERNEL_ASM_O} ${KERNEL_O} ${QOSCLIB_O}
	#merge and link correct addresses to kernel files
	i686-elf-ld -g -relocatable $^ -o ${KERNEL_MERGED}
	${CC} ${CFLAGS} ${INCLUDES} -T ./src/linker.ld -o $@ ${KERNEL_MERGED}

${QOSCLIB_O}: ${QLIB_O}
	i686-elf-ld -g -relocatable $^ -o $@


#Pattern Rules
${BUILD_DIR}/%.o: ${SRC_DIR}/%.c ${HEADERS}
	mkdir -p $(dir $@)
	$(CC) ${CFLAGS} ${INCLUDES} -c $< -o $@

${BUILD_DIR}/%.asm.o: ${SRC_DIR}/%.asm
	mkdir -p $(dir $@)
	${ASM} ${ASMFLAGS} -f elf $< -o $@


debug: ${OS_BIN}
	cgdb -x ./debug/qemugdbinit 

maps: ${OS_BIN}
	ctags -R
	cscospe -R

dump-boot: ${BOOT_BIN}
	objdump -D -Mintel,i8086 -b binary -m i386 $<

dump-bin: ${OS_BIN}
	objdump -D -b binary -m i386 $<

run: ${OS_BIN}
	qemu-system-i386 $< 

clean: 
	rm -rf ${BIN_DIR}/*
	rm -rf ${BUILD_DIR}/*
	rm -rf ${QLIB_O}
	rm -rf ${QOSCLIB_O}
	rm -f ./tags ./cscope.out

