# Assembly code that sets up the initial environment for the unikernel.

# Declare constants for the multiboot header.
.set ALIGN,    1<<0             # Align loaded modules on page boundaries.
.set MEMINFO,  1<<1             # Provide memory map.
.set FLAGS,    ALIGN | MEMINFO  # This is the Multiboot 'flags' field.
.set MAGIC,    0x1BADB002       # The magic number for the Multiboot header.
.set CHECKSUM, -(MAGIC + FLAGS) # The checksum.

# Multiboot header section. Must be at the start of the unikernel binary.
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Stack section. Allocates 16KB of space for the stack.
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

# Text section. Initialization code, the linker script specifies _start as the entry point.
.section .text
.global _start
.type _start, @function
_start:
    # Set up the stack pointer. Its grows downwards, point esp to the top of the stack space.
    mov $stack_top, %esp

    # Call the C kernel's main function.
    call kmain

    # If kmain should never return, if it does halt the CPU.
#    cli
#1:  hlt
#    jmp 1b

cli
halt:
    hlt
    jmp halt

.size _start, . - _start
