MEMORY { SRAM : ORIGIN = 0,
		LENGTH = 0x10000 }
MEMORY { DDR : ORIGIN = 0x40000000,
		LENGTH = 0x40000000 }

ENTRY(_start)
SECTIONS
{
	.text : 
	{
		start.o (.text)
		*(.text) 
	} > SRAM
	.rodata : { *(.rodata) } > SRAM
	.data : { *(.data) } > SRAM
	
	.stack : {	
	. = ALIGN(8);
	. = . + 0x100; /* 4kB of stack memory */
	stack_top = .;
	} > SRAM

	.bss : { *(.bss COMMON) } > DDR
}
