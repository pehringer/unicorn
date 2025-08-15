#ifndef KDIS_H
#define KDIS_H

int kdis_write(char c, unsigned int row, unsigned int column);

unsigned int kdis_columns(void);

unsigned int kdis_rows(void);

int kdis_print(const char *string);

#endif
