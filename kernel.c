// C code for a simple freestanding kernel that prints "Hello, World!".

// The VGA video memory address.
volatile unsigned short* vga_buffer = (unsigned short*)0xB8000;
// The current position on the screen.
int vga_x = 0;
int vga_y = 0;

// VGA color constants.
// The attribute byte is comprised of two nibbles:
// background color in the high nibble and foreground color in the low nibble.
enum vga_color {
    COLOR_BLACK = 0,
    COLOR_BLUE = 1,
    COLOR_GREEN = 2,
    COLOR_CYAN = 3,
    COLOR_RED = 4,
    COLOR_MAGENTA = 5,
    COLOR_BROWN = 6,
    COLOR_LIGHT_GREY = 7,
    COLOR_DARK_GREY = 8,
    COLOR_LIGHT_BLUE = 9,
    COLOR_LIGHT_GREEN = 10,
    COLOR_LIGHT_CYAN = 11,
    COLOR_LIGHT_RED = 12,
    COLOR_LIGHT_MAGENTA = 13,
    COLOR_LIGHT_BROWN = 14,
    COLOR_WHITE = 15,
};

// Combines foreground and background colors into a single attribute byte.
unsigned char make_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg << 4;
}

// Creates a VGA character entry from a character and a color attribute.
unsigned short make_vga_char(char c, unsigned char color) {
    return (unsigned short)c | (unsigned short)color << 8;
}

// Prints a single character to the screen.
void putchar(char c, unsigned char color, int x, int y) {
    const int index = y * 80 + x;
    vga_buffer[index] = make_vga_char(c, color);
}

// Prints a null-terminated string to the screen.
void print(const char* str) {
    unsigned char color = make_color(COLOR_LIGHT_GREEN, COLOR_BLACK);
    for (int i = 0; str[i] != '\0'; i++) {
        // Handle newlines
        if (str[i] == '\n') {
            vga_x = 0;
            vga_y++;
            continue;
        }
        putchar(str[i], color, vga_x, vga_y);
        vga_x++;
        // Handle line wrapping
        if (vga_x >= 80) {
            vga_x = 0;
            vga_y++;
        }
    }
}

// The kernel's main entry point.
void kmain(void) {
    // Clear the screen by printing spaces everywhere.
    unsigned char clear_color = make_color(COLOR_BLACK, COLOR_BLACK);
    for (int y = 0; y < 25; y++) {
        for (int x = 0; x < 80; x++) {
            putchar(' ', clear_color, x, y);
        }
    }

    // Reset cursor position and print the message.
    vga_x = 0;
    vga_y = 0;
    print("Hello World! This is the unicorn unikernel!");
    // Halt the CPU.
    while (1) {}
}
