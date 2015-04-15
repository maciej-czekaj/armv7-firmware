CROSS_COMPILE=
CC=$(CROSS_COMPILE)gcc
OBJCP=$(CROSS_COMPILE)objcopy
LD=$(CROSS_COMPILE)ld
OBJDMP=$(CROSS_COMPILE)objdump
CFLAGS=-O3 -D_GNU_SOURCE

all: mksunxiboot fel

mksunxiboot: mksunxiboot.c

LIBUSB = libusb-1.0
LIBUSB_CFLAGS = `pkg-config --cflags $(LIBUSB)`
LIBUSB_LIBS = `pkg-config --libs $(LIBUSB)`

fel: fel.c
	$(CC) $(CFLAGS) $(LIBUSB_CFLAGS) $(LDFLAGS) -o $@ $(filter %.c,$^) $(LIBS) $(LIBUSB_LIBS)

clean:
	rm -f mksunxiboot fel

