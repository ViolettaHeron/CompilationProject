#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <glib.h>
#include "syntaxe_simple.tab.h"
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
#define EGALITE         19
#define DIFFERENT       20
#define SUPERIEUR       21
#define INFERIEUR       22
#define SUPEGAL         23
#define INFEGAL         24
#define DANSII          25      /* inclus-inclus */
#define DANSEI          26      /* exclus-inclus */
#define DANSIE          27      /* inclus-exclus */
#define DANSEE          28      /* exclus-exclus */
#define CONDITION_SI    29
#define CONDITION_SI_SINON 30
#define SI          	31
#define SINON       	32
#define NEGATIF     	33
#define BLOC_CODE     	34
#define BOUCLE_FOR     	35
#define BOUCLE_WHILE   	36
#define VIRGULE   	37
#define AFFECT   	38
#define	PRINCIPAL	39
#define MAIN	        40
#define RET	        41
#define EXT	        42

