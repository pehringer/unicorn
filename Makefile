# Makefile for building the unikernel.

# Directories.
INC_DIR = kernel/include
SRC_DIR = kernel/src
OBJ_DIR = build/obj
BIN_DIR = build/bin
ISO_DIR = build/iso

# Source files.
ARCH_SRC = $(SRC_DIR)/arch.s
BOOT_SRC = $(SRC_DIR)/boot.s
KSTART_SRC = $(SRC_DIR)/kstart.c
KSER_SRC = $(SRC_DIR)/kser.c

# Object files.
ARCH_OBJ = $(OBJ_DIR)/arch.o
BOOT_OBJ = $(OBJ_DIR)/boot.o
KSTART_OBJ = $(OBJ_DIR)/kstart.o
KSER_OBJ = $(OBJ_DIR)/kser.o

# Output Targets.
TARGET = unikernel
TARGET_BIN = $(BIN_DIR)/$(TARGET).bin
TARGET_ISO = $(BIN_DIR)/$(TARGET).iso

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

all: $(TARGET_BIN)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(ARCH_OBJ): $(ARCH_SRC) $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(ARCH_SRC) -o $(ARCH_OBJ)

$(BOOT_OBJ): $(BOOT_SRC) $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(BOOT_SRC) -o $(BOOT_OBJ)

$(KSTART_OBJ): $(KSTART_SRC) $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(KSTART_SRC) -o $(KSTART_OBJ)

$(KSER_OBJ): $(KSER_SRC) $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(KSER_SRC) -o $(KSER_OBJ)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(TARGET_BIN): $(ARCH_OBJ) $(BOOT_OBJ) $(KSTART_OBJ) $(KSER_OBJ) $(BIN_DIR)
	$(LD) -m elf_i386 -T link.ld -o $(TARGET_BIN) $(ARCH_OBJ) $(BOOT_OBJ) $(KSTART_OBJ) $(KSER_OBJ)

# Create a GRUB2 ISO disk image.
$(TARGET_ISO): $(TARGET_BIN)
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(TARGET_BIN) $(ISO_DIR)/boot/$(TARGET).bin
	# Create grub.cfg file.
	echo 'set timeout=0' > $(ISO_DIR)/boot/grub/grub.cfg
	echo 'set default=0' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo 'menuentry "$(TARGET)" {' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '   multiboot /boot/$(TARGET).bin' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '   boot' >> $(ISO_DIR)/boot/grub/grub.cfg
	echo '}' >> $(ISO_DIR)/boot/grub/grub.cfg
	# Generate ISO with GRUB bootloader.
	grub2-mkrescue -o $(TARGET_ISO) $(ISO_DIR)

run: $(TARGET_ISO)
	qemu-system-x86_64 -cdrom $(TARGET_ISO) -nographic

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(ISO_DIR)
