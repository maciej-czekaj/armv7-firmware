

#define readb(a)			(*(volatile unsigned char *)(a))
#define readw(a)			(*(volatile unsigned short *)(a))
#define readl(a)			(*(volatile unsigned int *)(a))

#define writeb(v,a)		(*(volatile unsigned char *)(a) = (v))
#define writew(v,a)		(*(volatile unsigned short *)(a) = (v))
#define writel(v,a)		(*(volatile unsigned int *)(a) = (v))

#define UART_BASE 0x01C28000
#define UART_THR (UART_BASE + 0x00)
#define UART_RBR (UART_BASE + 0x00)
#define UART_DLL (UART_BASE + 0x00)
#define UART_DLH (UART_BASE + 0x04)
#define UART_LCR (UART_BASE + 0x0c)
#define UART_LSR (UART_BASE + 0x14)

#define UART_LCR_DLAB (0x1 << 7)

#define UART_LSR_TEMT (0x1 << 6)
#define BAUD_115200 13 /*clock 24M / (16*115200) */
#define NO_PARITY      (0)
#define ONE_STOP_BIT   (0)
#define DAT_LEN_8_BITS (3)
#define LC_8_N_1          (NO_PARITY << 3 | ONE_STOP_BIT << 2 | DAT_LEN_8_BITS)

void uart_init(void)
{
	/* select dll dlh */
	writel(UART_LCR_DLAB, UART_LCR);
	/* set baudrate */
	writel(0, UART_DLH);
	writel(BAUD_115200, UART_DLL);
	/* set line control */
	writel(LC_8_N_1, UART_LCR);
}

#define TX_READY (readl(UART_LSR) & UART_LSR_TEMT)

void uart_putc(char c)
{
	while (!TX_READY)
		;
	writel(c, UART_THR);
}

void uart_puts(const char *s)
{
	while (*s)
		uart_putc(*s++);
}


void main(void)
{
	*(int *)(0x3000) = 0x44444444;
	//uart_init();
	//uart_puts("Hello world!");
}

