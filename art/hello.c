static int x[2];
static int y[2] = {0xbabababa};

void foo(const char *s,int *i, int *j) {}

void _start(void) {
  int a = 0xdeadbeef;
  foo("Hello World %x\n", y, x);
}
