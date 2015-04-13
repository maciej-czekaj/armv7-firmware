CROSS_COMPILE=arm-none-eabi-
CC=$(CROSS_COMPILE)gcc
OBJCP=$(CROSS_COMPILE)objcopy
LD=$(CROSS_COMPILE)ld
OBJDMP=$(CROSS_COMPILE)objdump
CFLAGS=-g

SCRIPT=image-sram.lds

all: uimage


OBJS = main.o start.o

start.o: start.S

main.o: main.c

image.elf: $(OBJS) image.lds
	$(LD) -T $(SCRIPT) $(OBJS) -o $@ -Map=image.map
	$(OBJDMP) -d $@ > $(@:.elf=.s)

image.bin: image.elf
	$(OBJCP) -O binary $< $@

uimage-addr:
	mkimage -A arm -O linux -T kernel -C none \
		-a 0x${ADDR} -e 0x${ADDR} -n hello -d image.bin uimage

uimage: image.bin
	$(MAKE) uimage-addr ADDR=`nm image.elf  |  awk '/_start/ {print $$1}'`

clean:
	rm -f $(OBJS) image.elf image.s image uimage

