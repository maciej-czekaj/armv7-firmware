CFLAGS=-O0 -g -Wall -Werror -Wextra

all: dump.txt

hello.o: hello.c
	arm-linux-gnueabihf-gcc -marm -O0 -c hello.c

hello: hello.o
	arm-linux-gnueabihf-ld -o hello hello.o

dump.txt: hello
	arm-linux-gnueabihf-objdump -fshd $< > dump.txt
	arm-linux-gnueabihf-objdump -d $< > dump.s

hp: hp.c
