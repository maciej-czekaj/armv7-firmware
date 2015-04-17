

#define readb(a)		(*(volatile unsigned char *)(a))
#define readw(a)		(*(volatile unsigned short *)(a))
#define readl(a)		(*(volatile unsigned int *)(a))

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

#include <stdint.h>

void delay(unsigned cycles)
{
	unsigned i;
	for(i = 0; i < cycles; i++ )
		__asm volatile ("nop"::);
}

void uart_init(void)
{
	/* Config APB clock gating for UART0 */
	volatile uint32_t *reg = (uint32_t *)0x01c2006C;
	unsigned port = 0;

	*reg &= ~(1 << (16 + port));
	// wait
	delay(100);

	*reg |=  (1 << (16 + port));

	// Set UART0 RX & UART0_TX port mux
	// PB22 && PB23
	volatile uint32_t *PB2 = (uint32_t *)0x01C2082C;
	*PB2 |= 2 << 28 | 2 << 24;

	// Set pull up (2) for PB22 & PB23
	volatile uint32_t *PB_PULL1 = (uint32_t *)0x01C20844;
	*PB_PULL1 |= (2 << ((22-16)*2)) | (2 << ((23-16)*2));

	/* select dll dlh */
	writel(UART_LCR_DLAB, UART_LCR);
	/* set baudrate */
	writel(0, UART_DLH);
	writel(BAUD_115200, UART_DLL);
	/* set line control */
	writel(LC_8_N_1, UART_LCR);

	delay(100);
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
	volatile uint32_t *debug = (uint32_t *)0x3008;
	*debug = 0x44444444;
	uart_init();
	writel('@', UART_THR);
	uart_puts("Hello world!\n\r");
	*debug = 0x55555555;
}

