/* Multiboot2 header (first 32KB, 8-byte aligned) */
.section .multiboot2_header
.align 8
multiboot2_header_start:
	.long 0xE85250D6 /* magic */
	.long 0          /* arch = i386 */
	.long multiboot2_header_end - multiboot2_header_start
	.long -(0xE85250D6 + 0 + (multiboot2_header_end - multiboot2_header_start))
multiboot2_header_tags:
	.short 0 /* end tag type */
	.short 0 /* flags */
	.long 8  /* size */
multiboot2_header_end:

/* Stack (16 KB) */
.section .bss
.align 16
stack_bottom:
	.skip 16384
stack_top:

/* Entry point */
.section .text
.global _start
.type _start, @function
_start:
	mov $stack_top, %esp
	push %ebx /* arg1 = pointer to multiboot info */
	push %eax /* arg0 = magic */
	call kstart
	cli
.halt:
	hlt
	jmp .halt

.size _start, . - _start
