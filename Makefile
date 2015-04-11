CC=arm-none-eabi-gcc
OBJCP=arm-none-eabi-objcopy
LD=arm-none-eabi-ld

all: image

start.o: start.S

main.o: main.c

image.elf: main.o start.o
	$(LD) -T image.lds $? -o $@

image: image.elf
	$(OBJCP) -O binary $< $@

