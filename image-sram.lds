ENTRY(_start)
SECTIONS
{
  . = 0x2000; /* Zaczynaj od 0x2000 */
  .text : 
  {
    start.o (.text)
    *(.text) 
  }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  
  .stack : {
    . = ALIGN(8); /* Stos wyrównany do 8 */
    . = . + 0x400; /* 1KB */
    stack_top = .;
  }
  
  .bss ALIGN(4) : { /* .bss wyrównany do 4 */
    bss_start = .;
    *(.bss COMMON)
    bss_end = ALIGN(4) 
   /* .bss kończy się wyrównaniem do 4, 
   dzięki czemu rozmiar jest wielokrotnością 4 */;
  }
}
