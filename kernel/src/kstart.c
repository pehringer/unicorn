#include "kser.h"

void kstart(void) {
	kser_init();

	unsigned char c;
	while(kser_put('0') != 0);
	while(kser_get(&c) != 0);
	while(kser_put('1') != 0);
	while(kser_put(c) != 0);
	while(kser_put('2') != 0);

	while(1) {}
}
