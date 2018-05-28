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

FILE* fichier;

extern void debut_code(void);
extern void genere_code(GNode*);
extern void fin_code(void);

/* Definition des sequences de code possibles pour Arbre Syntaxique. Chaque sequence de code est associe a un numerique. */
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
#define EGALITE         19
#define DIFFERENT       20
#define SUPERIEUR       21
#define INFERIEUR       22
#define SUPEGAL         23
#define INFEGAL         24
#define CONDITION_SI    25
#define CONDITION_SI_SINON 26
#define SI          	27
#define SINON       	28
#define NEGATIF     	29
#define BLOC_CODE     	30
#define BOUCLE_FOR     	31
#define BOUCLE_WHILE   	32
#define VIRGULE   	33
#define AFFECT   	34
#define	PRINCIPAL	35
#define MAIN	        36
#define RET	        37
#define EXT	        38
#define BRK	        39
#define DECD	        40
#define DECG	        41
#define FONCTION	42
#define INT_TABLEAUX	43
#define AFFECT_TABLEAUX	44

