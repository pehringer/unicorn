#include "kdis.h"

// The kernel entry point.
void kstart(void) {
	for (unsigned int i = 0; i < kdis_rows(); i++) {
		kdis_newline();
	}
	kdis_string("Hello World!", 12);
	kdis_newline();
	kdis_string("This is the unicorn unikernel!", 30);
	while (1) {}
}
