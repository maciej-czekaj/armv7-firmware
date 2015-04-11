if [ -n "$1" ]
then
S="-s -S"
fi
qemu-system-arm -M cubieboard -m 1M -nographic $S -kernel uimage
