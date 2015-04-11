CROSS_COMPILE=arm-none-eabi-
CC=arm-none-eabi-gcc
OBJCP=arm-none-eabi-objcopy
LD=arm-none-eabi-ld
OBJDMP=$(CROSS_COMPILE)objdump
CFLAGS=-g
all: image

OBJS = main.o start.o

start.o: start.S

main.o: main.c

image.elf: $(OBJS) image.lds
	$(LD) -T image.lds $(OBJS) -o $@
	$(OBJDMP) -d $@ > $(@:.elf=.s)

image: image.elf
	$(OBJCP) -O binary $< $@
	$(MAKE) uimage ADDR=`nm image.elf  |  awk '/_start/ {print $$1}'`

uimage: image
	mkimage -A arm -O linux -T kernel -C none \
		-a 0x${ADDR} -e 0x${ADDR} -n hello -d image uimage

clean:
	rm -f $(OBJS) image.elf image.s image uimage

