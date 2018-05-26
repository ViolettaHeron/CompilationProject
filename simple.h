#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <glib.h>
#include "cfe.tab.h"
int yylex(void);
void yyerror(char*);
extern unsigned int lineno;
extern bool error_lexical;

/* Le flux de notre fichier de sortie final */
FILE* fichier;

/* Definition des methodes de generation de code C */
extern void debut_code(void);
extern void genere_code(GNode*);
extern void fin_code(void);

/* Definition des sequences de code possibles pour l'AST (Arbre Syntaxique). Chaque sequence de code est associe a un numerique. */
#define CODE_VIDE	0
#define SEQUENCE	1
#define	VARIABLE	2
#define AFFECTATION	3
#define AFFECTATIONE	4
#define AFFECTATIONB	5
#define	AFFICHAGEE	6
#define	AFFICHAGEB	7
#define ENTIER		8
#define ADDITION	9
#define	SOUSTRACTION	10
#define MULTIPLICATION	11
#define DIVISION	12
#define ET		13
#define OU		14
#define NON		15
#define VRAI		16
#define FAUX		17
#define	EXPR_PAR	18
#define	PRINCIPAL	19
#define BLOC_CODE       20
#define MAIN	        21
#define EGALITE         22
#define DIFFERENT       23
#define SUPERIEUR       24
#define INFERIEUR       25
#define SUPEGAL         26
#define INFEGAL         27

