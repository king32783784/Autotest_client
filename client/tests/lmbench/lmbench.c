/*
 *
 *  Portions Copyright (C) 2012 wind (isoft.com)
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
#include <stdio.h>
#include <string.h>

static char buffer[1024];
static char* iter = buffer;

void putstring()
{
	char* p = buffer;
	for (;*p;) putchar(*p++);
	memset(buffer, 0, sizeof(buffer));
	iter = buffer;
}

void putstring_k()
{
	char* dec = 0;
	char* p = buffer;
	for (; *p; p++) {
		if ('.' == *p) {
			dec = p;
			continue;
		}
		putchar(*p);
	}
	int n = 3 - (p - dec);
	int i;
	for (i = 0; i <= n; i++) putchar('0');

	memset(buffer, 0, sizeof(buffer));
	iter = buffer;
}

int processing(int c)
{
	if ('k' == c || 'K' == c)  {
		putstring_k();
		return 0;
	}
	*iter++ = c;
}

int main(int argc, char* argv[])
{
	FILE* fp = 0;
	if (argc < 2)
		fp = fdopen(0, "r");
	else
		fp = fopen(argv[1], "r");

	memset(buffer, 0, sizeof(buffer));

	int c = 0;
	while (EOF != (c = fgetc(fp))) {
		if (isspace(c)) {
			putstring();
			putchar(c);
		} else
			processing(c);
	}
    return 0;
}

