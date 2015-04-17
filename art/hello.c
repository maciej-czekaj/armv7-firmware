static int x[1];
static int y[1] = {0xbabababa};

void foo(const char *s,int *i, int *j) {}

void _start(void) {
  foo("Hello World", y, x);
}
