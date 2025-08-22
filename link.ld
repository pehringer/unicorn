/* Entry point */
ENTRY(_start)

/* Memory regions */
MEMORY {
	TEXT (rx) : ORIGIN = 0x00100000, LENGTH = 1M /* Code + read-only constants */
	DATA (rw) : ORIGIN = 0x00200000, LENGTH = 1M /* Globals, stack, BSS */
}

/* Sections mapped to memory regions */
SECTIONS {
	. = ORIGIN(TEXT);

	/* Multiboot2 header and code */
	.text : {
		KEEP(*(.multiboot2_header)) /* Required for GRUB */
		*(.text*)                   /* All code (_start, functions) */
	} > TEXT

	/* Read-only constants */
	.rodata : { *(.rodata*) } > TEXT

	/* Switch to DATA region */
	. = ORIGIN(DATA);

	/* Initialized globals */
	.data : { *(.data*) } > DATA

	/* Uninitialized globals / BSS */
	.bss  : { *(.bss*) }  > DATA
}
