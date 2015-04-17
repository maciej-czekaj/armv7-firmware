ENTRY(_start)
SECTIONS
{
	. = 0x2000;
	.text : 
	{
		start.o (.text)
		*(.text) 
	}
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	
	.stack : {
	. = ALIGN(8);
	. = . + 0x400; /* 1kB of stack memory */
	stack_top = .;
	}

	.bss : { *(.bss COMMON) }
}
