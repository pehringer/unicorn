#include "kser.h"

static const unsigned short COM1_THR = 0x03F8; // Transmit Holding Register
static const unsigned short COM1_RBR = 0x03F8; // Receiver Buffer Register
static const unsigned short COM1_DLL = 0x03F8; // Divisor Latch Low

static const unsigned short COM1_IER = 0x03F9; // Interrupt Enable Register
static const unsigned short COM1_DLH = 0x03F9; // Divisor Latch High

static const unsigned short COM1_FCR = 0x03FA; // FIFO Control Register

static const unsigned short COM1_LCR = 0x03FB; // Line Control Register

static const unsigned short COM1_LSR = 0x03FD; // Line Status Register
static const unsigned char COM1_LSR_THRE = 0x20; // Transmit Holding Register Empty
static const unsigned char COM1_LSR_RDR = 0x01; // Receiver Data Ready

static inline void outb(unsigned short port, unsigned char byte) {
    __asm__ volatile ("outb %0, %1" : : "a"(byte), "Nd"(port));
}

static inline unsigned char inb(unsigned short port) {
    unsigned char byte;
    __asm__ volatile ("inb %1, %0" : "=a"(byte) : "Nd"(port));
    return byte;
}

int kser_init(void) {
    outb(COM1_IER, 0x00); // Disable interrupts.
    outb(COM1_LCR, 0x80); // Enable DLAB to set baud rate.
    outb(COM1_DLL, 0x01); // Set divisor = 1 for 115200 baud.
    outb(COM1_DLH, 0x00); // Set divisor = 1 for 115200 baud.
    outb(COM1_LCR, 0x03); // 8 bits, no parity, 1 stop bit.
    outb(COM1_FCR, 0xC7); // Enable FIFO, clear them.
    return 0;
}

int kser_put(unsigned char byte) {
	if (!(inb(COM1_LSR) & COM1_LSR_THRE)) {
		return -1;
	}
	outb(COM1_THR, byte);
	return 0;
}

int kser_get(unsigned char *byte) {
	if (!(inb(COM1_LSR) & COM1_LSR_RDR)) {
		return -1;
	}
	*byte = inb(COM1_RBR);
	return 0;
}
