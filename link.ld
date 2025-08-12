/* ld script that controls how the final unikernel binary is structured. */

/* The unikernel entry point is the `_start` function in boot.s. */
ENTRY(_start)

/* Define memory regions with appropriate permissions */
MEMORY
{
    /* Code segment: read + execute */
    TEXT (rx) : ORIGIN = 0x00100000, LENGTH = 1M

    /* Data segment: read + write */
    DATA (rw) : ORIGIN = 0x00200000, LENGTH = 1M
}

/* Sections mapped to the memory regions */
SECTIONS
{
    /* Start location aligned at 1MB (0x100000) in the TEXT segment */
    . = ORIGIN(TEXT);

    /* Text section with code */
    .text :
    {
        /* Place the multiboot header first */
        *(.multiboot)
        *(.text)
    } > TEXT

    /* Read-only data */
    .rodata :
    {
        *(.rodata)
    } > TEXT

    /* Move location counter to start of DATA region */
    . = ORIGIN(DATA);

    /* Initialized data */
    .data :
    {
        *(.data)
    } > DATA

    /* Uninitialized data (BSS) */
    .bss :
    {
        *(.bss)
    } > DATA
}
