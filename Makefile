
ifndef CROSS_COMPILE
$(error define CROSS_COMPILE env variable!)
endif

CC=$(CROSS_COMPILE)gcc
OBJCP=$(CROSS_COMPILE)objcopy
LD=$(CROSS_COMPILE)ld
OBJDMP=$(CROSS_COMPILE)objdump
CFLAGS=-g

FEL=./host/fel

ifeq ($(TARGET),qemu)
	SCRIPT = image-ddr.lds
	LDFLAGS=
	IMAGE=uimage
else
	SCRIPT=image-sram.lds
	BASE=0x4000
	LDFLAGS=-Ttext=$(BASE)
	IMAGE=image.sunxi.bin
endif

all: $(IMAGE)


OBJS = main.o start.o

start.o: start.S

main.o: main.c

image.elf: $(OBJS) $(SCRIPT)
	$(LD) -T $(SCRIPT) $(LDFLAGS) $(OBJS) -o $@ -Map=image.map
	$(OBJDMP) -d $@ > $(@:.elf=.s)

image.bin: image.elf
	$(OBJCP) -O binary $< $@

uimage-addr:
	mkimage -A arm -O linux -T kernel -C none \
		-a 0x${ADDR} -e 0x${ADDR} -n hello -d image.bin uimage

uimage: image.bin
	$(MAKE) uimage-addr ADDR=`nm image.elf  |  awk '/_start/ {print $$1}'`

image.sunxi.bin: image.bin
	./host/mksunxiboot $< $@

clean:
	rm -f $(OBJS) image.elf image.s image*.bin uimage

fel: image.bin
	$(FEL) write $(BASE) $<
	$(FEL) exe $(BASE)
	$(FEL) version #checks if alive
