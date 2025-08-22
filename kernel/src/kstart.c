#include "kser.h"

void kstart(unsigned int magic, unsigned int address) {
	kser_init();
	if (magic != 0x36d76289) {
		while (kser_put('N') != 0);
		while (kser_put('E') != 0);
		while (kser_put('Q') != 0);
	} else if (address == 0) {
		while (kser_put('N') != 0);
		while (kser_put('I') != 0);
		while (kser_put('L') != 0);
	} else {
		while (kser_put('O') != 0);
		while (kser_put('K') != 0);
	}
	unsigned char input;
	while (kser_get(&input) != 0);
	while (kser_put(input) != 0);
}
