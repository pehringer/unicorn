#include "kdis.h"

// Hardware specific code (vga text mode).

static volatile unsigned short * const vga_memory = (volatile unsigned short *)0xB8000;
static const unsigned short vga_color = 0x0F00;
static const unsigned int vga_columns = 80;
static const unsigned int vga_rows = 25;

int kdis_character(char c, unsigned int row, unsigned int column) {
	if(row >= vga_rows || column >= vga_columns) {
		return -1;
	}
	vga_memory[row * vga_columns + column] = vga_color | (unsigned short)c;
	return 0;
}

unsigned int kdis_columns(void) {
	return vga_columns;
}

unsigned int kdis_rows(void) {
	return vga_rows;
}

// Hardware agnostic code.

static unsigned int cursor_column = 0;
static unsigned int cursor_row = 0;

int kdis_string(const char *s, unsigned int length) {
	for(unsigned int i = 0; i < length; i++) {
		if(kdis_character(s[i], cursor_row, cursor_column) != 0) {
			return -1;
		}
		cursor_column++;
		if(cursor_column >= kdis_columns()) {
			cursor_column = 0;
			cursor_row++;
		}
		if(cursor_row >= kdis_rows()) {
			cursor_row = 0;
		}
	}
    	return 0;
}

int kdis_newline(void) {
	cursor_column = 0;
	cursor_row++;
	if(cursor_row >= kdis_rows()) {
		cursor_row = 0;
	}
	for(unsigned int i = 0; i < kdis_columns(); i++) {
		if(kdis_character(' ', cursor_row, i) != 0) {
			return -1;
		}
	}
	return 0;
}
