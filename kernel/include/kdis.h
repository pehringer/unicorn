#ifndef KDIS_H
#define KDIS_H

int kdis_character(char c, unsigned int row, unsigned int column);

unsigned int kdis_columns(void);

unsigned int kdis_rows(void);

int kdis_string(const char *s, unsigned int length);

int kdis_newline(void);

#endif
