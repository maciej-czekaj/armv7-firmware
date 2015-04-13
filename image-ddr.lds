ENTRY(_start)
SECTIONS
{
	. = 0x40000100;
	. = ALIGN(4);
	.text : 
	{
		start.o (.text)
		*(.text) 
	}
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	
	. = ALIGN(8);
	. = . + 0x1000; /* 4kB of stack memory */
	stack_top = .;

	.bss : { *(.bss COMMON) }
}
