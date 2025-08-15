#include "kdis.h"

// Hardware specific code (vga text mode).

static volatile unsigned short * const vga_memory = (volatile unsigned short *)0xB8000;
static const unsigned short vga_color = 0x0F00;
static const unsigned int vga_columns = 80;
static const unsigned int vga_rows = 25;

int kdis_write(char c, unsigned int row, unsigned int column) {
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

int back() {
	if(cursor_column == 0) {
		return 0;
	}
	cursor_column--;
	if(kdis_write(' ', cursor_row, cursor_column) != 0) {
		return -1;
	}
	return 0;
}

int tab() {
	return -1;
}

int newline() {
	cursor_column = 0;
	cursor_row++;
	if(cursor_row >= kdis_rows()) {
		cursor_row = 0;
	}
	for(unsigned int i = 0; i < kdis_columns(); i++) {
		if(kdis_write(' ', cursor_row, i) != 0) {
			return -1;
		}
	}
	return 0;
}

int carriage() {
	cursor_column = 0;
	return 0;
}

int character(char c) {
	switch(c) {
	case '\b':
		return back();
	case '\n':
		return newline();
	case '\r':
		return carriage();
	}
	if(kdis_write(c, cursor_row, cursor_column) != 0) {
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
	return 0;
}

int kdis_print(const char *string) {
	for(int i = 0; string[i] != '\0'; i++) {
		if(character(string[i]) != 0) {
			return -1;
		}
	}
	return 0;
}
