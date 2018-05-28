/* FICHIER GENERE PAR LE COMPILATEUR MONGCC */

#include<stdlib.h>
#include<stdbool.h>
#include<stdio.h>

extern int printd( int i );

int main() {
	int i;
	int j;
	i=45000;
	j=-123;
	printf("%ld\n",(i+j));
	printf("%ld\n",(45000+j));
	printf("%ld\n",(i+123));
	printf("%ld\n",(45000+123));
	printf("%ld\n",(i+(j+0)));
	printf("%ld\n",((i+0)+j));
	printf("%ld\n",((i+0)+(j+0)));
	printf("%ld\n",((i+0)+123));
	printf("%ld\n",(45000+(j+0)));
	return 0;
	}

