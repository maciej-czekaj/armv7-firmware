
#define readb(a)    (*(volatile unsigned char *)(a))
#define readw(a)    (*(volatile unsigned short *)(a))
#define readl(a)    (*(volatile unsigned int *)(a))

#define writeb(v,a)    (*(volatile unsigned char *)(a) = (v))
#define writew(v,a)    (*(volatile unsigned short *)(a) = (v))
#define writel(v,a)    (*(volatile unsigned int *)(a) = (v))

#define UART_PORT 0

#define UART_BASE 0x01C28000
#define UART_THR (UART_BASE + 0x00)
#define UART_RBR (UART_BASE + 0x00)
#define UART_DLL (UART_BASE + 0x00)
#define UART_DLH (UART_BASE + 0x04)
#define UART_LCR (UART_BASE + 0x0c)
#define UART_LSR (UART_BASE + 0x14)

#define UART_LCR_DLAB (0x1 << 7)

#define UART_LSR_TEMT (0x1 << 6)
#define BAUD_115200 13		/*clock 24M / (16*115200) */
#define NO_PARITY      (0)
#define ONE_STOP_BIT   (0)
#define DAT_LEN_8_BITS (3)
#define LC_8_N_1  (NO_PARITY << 3 | \
  ONE_STOP_BIT << 2 | DAT_LEN_8_BITS)

#include <stdint.h>

volatile uint32_t debug = 0xdeadbeef;

void delay(unsigned cycles)
{
  unsigned i;
  for (i = 0; i < cycles; i++)
    __asm volatile ("nop"::);
}

void uart_init(void)
{
  volatile uint32_t *uart_clock =
    (uint32_t *) 0x01C2006C;
  volatile uint32_t *PB2 =
    (uint32_t *) 0x01C2082C;
  volatile uint32_t *PB_PULL1 =
    (uint32_t *) 0x01C20844;

  /* Włączenie zegara dla urządzenia UART na szynie APB */
  *uart_clock &=
    ~(1 << (16 + UART_PORT));
  /* Trzeba odczekać parę cykli zegara */
  delay(100);
  *uart_clock |=
    (1 << (16 + UART_PORT));

  /* Ustaw piny 22 i 23 portu B 
     na UART0 RX & UART0_TX */
  *PB2 |= 2 << 28 | 2 << 24;

  /* Piny muszą być wyterowane jako pull-up
     (wartość 2) dla pinów 22 i 23 portu B */
  *PB_PULL1 |=
    (2 << ((22 - 16) * 2)) | 
    (2 << ((23 - 16) * 2));

  /* Aktywuj konfigurację szybkości transmisji */
  writel(UART_LCR_DLAB, UART_LCR);

  /* Ustaw prędkość portu na 115200 baud */
  writel(0, UART_DLH);
  writel(BAUD_115200, UART_DLL);

  /* Wyłącz konf trasmisji i ustaw:
     - brak parzystości
     - 1 bit stopu
     - długość słowa 8 bitów */
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
  debug = 0x44444444;
  uart_init();
  uart_puts("Hello world!\n\r");
  debug = 0x55555555;
}
