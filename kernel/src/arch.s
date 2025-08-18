# Assembly code for all architecture specific routines.

.section .text
# void outb(unsigned short port, unsigned char val)
.global outb
.type outb, @function
outb:
    # stack layout: [esp] return addr, [esp+4] port, [esp+8] val
    mov 8(%esp), %al      # val -> AL
    mov 4(%esp), %dx      # port -> DX
    out %al, %dx
    ret
# unsigned char inb(unsigned short port)
.global inb
.type inb, @function
inb:
    mov 4(%esp), %dx      # port -> DX
    in %dx, %al
    ret
