# Makefile for building the unikernel.

# Compiler flags to use.
# -m32: Compile for 32-bit architecture.
# -ffreestanding: Don't assume a standard library is present.
# -nostdlib: Don't link against the standard library.
# -fno-pie: Don't create a position-independent executable.
# -g: Include debug information.
CC = gcc
CFLAGS = -m32 -ffreestanding -nostdlib -fno-pie -g -Wall -Wextra

LD = ld
OBJS = boot.o kstart.o

TARGET = unikernel.bin

# Run the unikernel in qemu.
run: $(TARGET)
	qemu-system-i386 -kernel $(TARGET)

# Link object files into the final unikernel binary.
$(TARGET): $(OBJS)
	$(LD) -m elf_i386 -T link.ld -o $(TARGET) $(OBJS)

# Compile assembly boot file (contains multiboot header and entry point).
boot.o: boot.s
	$(CC) $(CFLAGS) -c boot.s -o boot.o

# Compile C kernel file (contains the kernel library).
kstart.o: kstart.c
	$(CC) $(CFLAGS) -c kstart.c -o kstart.o

# Clean up build files.
clean:
	rm -f $(TARGET) $(OBJS)
