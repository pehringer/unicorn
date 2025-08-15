#include "kdis.h"

// The kernel entry point.
void kstart(void) {
	kdis_print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
	kdis_print("Hello World!\n");
	kdis_print("Unikorn Kernal!\b\b\bel!\rUnic\n");
	for(unsigned int i = 0; i < (kdis_rows() - 2) * kdis_columns(); i++) {
		kdis_print("@");
	}
	while (1) {}
}
