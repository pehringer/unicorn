#ifndef KSER_H
#define KSER_H

int kser_init();

int kser_put(unsigned char byte);

int kser_get(unsigned char *byte);

#endif
