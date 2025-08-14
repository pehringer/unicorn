# Makefile for building the unikernel.

# Directories.
INC_DIR = kernel/include
SRC_DIR = kernel/src
OBJ_DIR = build/obj
BIN_DIR = build/bin

# Source files.
BOOT_SRC = $(SRC_DIR)/boot.s
KSTART_SRC = $(SRC_DIR)/kstart.c
KDIS_SRC = $(SRC_DIR)/kdis.c

# Object files.
BOOT_OBJ = $(OBJ_DIR)/boot.o
KSTART_OBJ = $(OBJ_DIR)/kstart.o
KDIS_OBJ = $(OBJ_DIR)/kdis.o

# Target binary.
TARGET = $(BIN_DIR)/unikernel.bin

# Compiler.
# -m32: Compile for 32-bit architecture.
# -ffreestanding: Don't assume a standard library is present.
# -nostdlib: Don't link against the standard library.
# -fno-pie: Don't create a position-independent executable.
# -g: Include debug information.
CC = gcc
CFLAGS = -m32 -ffreestanding -nostdlib -fno-pie -g -Wall -Wextra -I$(INC_DIR)

# Linker.
LD = ld

# Default target.
all: $(TARGET)

# Link the final binary.
$(TARGET): $(BOOT_OBJ) $(KSTART_OBJ) $(KDIS_OBJ)
	mkdir -p $(BIN_DIR)
	$(LD) -m elf_i386 -T link.ld -o $(TARGET) $(BOOT_OBJ) $(KSTART_OBJ) $(KDIS_OBJ)

# Compile assembly boot file.
$(BOOT_OBJ): $(BOOT_SRC)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(BOOT_SRC) -o $(BOOT_OBJ)

# Compile C kernel start file.
$(KSTART_OBJ): $(KSTART_SRC)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(KSTART_SRC) -o $(KSTART_OBJ)

# Compile C kernal library display file.
$(KDIS_OBJ): $(KDIS_SRC)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(KDIS_SRC) -o $(KDIS_OBJ)

# Run the unikernel in QEMU
run: $(TARGET)
	qemu-system-i386 -kernel $(TARGET)

# Clean build files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)
