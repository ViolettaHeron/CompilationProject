%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	int yylex();
	void yyerror(char const *s);
	char* concatTab(char* str1, char* str2);
%}

%token IDENTIFICATEUR CONSTANTE VOID INT FOR WHILE IF ELSE SWITCH CASE DEFAULT
%token BREAK RETURN PLUS MOINS MUL DIV LSHIFT RSHIFT BAND BOR LAND LOR LT GT 
%token GEQ LEQ EQ NEQ NOT EXTERN
%left PLUS MOINS
%left MUL DIV
%left LSHIFT RSHIFT
%left BOR BAND
%left LAND LOR
%left OP
%left REL

%nonassoc THEN
%nonassoc ELSE
%start programme

%union {
	char* nom_id;
	int valeur;
	char* code;
	char* liste_variables;
}

%type<liste_variables> declaration
%type<liste_variables> liste_declarateurs
%type<nom_id> declarateur

%type<nom_id> IDENTIFICATEUR
%type<valeur> CONSTANTE

%%

programme	:	
	 liste_declarations liste_fonctions 	
;

liste_declarations	:
		liste_declarations declaration 	{ printf("\tint %s;\n", $2); }
	| 									
;

liste_fonctions	:	
		liste_fonctions fonction 		
	|	fonction 						
;

declaration	:	
	 type liste_declarateurs ';' 			{ $$ = $2; }
;

liste_declarateurs	:	
		liste_declarateurs ',' declarateur	{ $$ = concatTab(concatTab($1, ", "), $3); }
	| 	declarateur 						{ $$ = strdup($1); }
;

declarateur	:	
	 	IDENTIFICATEUR						{  $$ = $1; } 			// fetch + insert in symbol table
	| 	declarateur '[' CONSTANTE ']' 		{  char* cons=malloc(sizeof(char));sprintf(cons, "[%d]", $3);$$ = concatTab($1,cons); }
;

fonction	:	
		type IDENTIFICATEUR '(' liste_parms ')' '{' liste_declarations liste_instructions '}'
	|	EXTERN type IDENTIFICATEUR '(' liste_parms ')' ';'
;

type	:	
		VOID
	|	INT
;

 liste_parms	: 
 	 parm 
 	| liste_parms ',' parm 
 	| 
;

parm	:	
	 INT IDENTIFICATEUR
;

liste_instructions :	
	 liste_instructions instruction
	|
;

instruction	:	
	 iteration
	| selection
	| saut
	| affectation ';'
	| bloc
	| appel
;

iteration	:	
	 FOR '(' affectation ';' condition ';' affectation ')' instruction
	| WHILE '(' condition ')' instruction
;

selection	:	
	 IF '(' condition ')' instruction %prec THEN
	| IF '(' condition ')' instruction ELSE instruction
	| SWITCH '(' expression ')' instruction
	| CASE CONSTANTE ':' instruction
	| DEFAULT ':' instruction
;

saut	:	
	 BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
;
affectation	:	
	 variable '=' expression
;

bloc	:	
	 '{' liste_declarations liste_instructions '}' 	// mettre à jour le pointeur de la table de symboles locale en rentrant dans un bloc
;

appel	:	
	 IDENTIFICATEUR '(' liste_expressions ')' ';'
;

variable	:	
	 IDENTIFICATEUR
	| variable '[' expression ']'
;

expression	:	
	 '(' expression ')'
	| expression binary_op expression %prec OP
	| MOINS expression
	| CONSTANTE
	| variable
	| IDENTIFICATEUR '(' liste_expressions ')'
;

liste_expressions	: 
	 expression 
	| liste_expressions ',' expression 
	| 
;

condition	:	
	 NOT '(' condition ')'
	| condition binary_rel condition %prec REL
	| '(' condition ')'
	| expression binary_comp expression
;

binary_op	:	
	 PLUS		{ printf("+\n"); }
	| MOINS		{ printf("-\n"); }
	| MUL		{ printf("*\n"); }
	| DIV		{ printf("/\n"); }
	| BAND		{ printf("&\n"); }
	| BOR 		{ printf("|\n"); }
	| LSHIFT	{ printf("<<\n"); }
	| RSHIFT	{ printf(">>\n"); }
;

binary_rel	:	
	 LAND 		{ printf("&&\n"); }
	| LOR		{ printf("||\n"); }
;

binary_comp	:	
	 LT			{ printf("<\n"); }
	| GT		{ printf(">\n"); }
	| GEQ		{ printf("<=\n"); }
	| LEQ		{ printf(">=\n"); }
	| EQ		{ printf("==\n"); }
	| NEQ		{ printf("!=\n"); }
;
%%

void yyerror(char const *s) {
	fprintf(stderr, "%s on char : %c \n", s, yychar);
	exit(1);
}

int main(void){
	yyparse();
	fprintf(stdout, "NO PARSE ERROR\n");
}


char* concatTab(char* str1, char* str2){
	char * new_str ;
	int strsize = strlen(str1)+strlen(str2)+1;

	if((new_str = malloc(strsize)) != NULL){
	    memset(new_str, '\0', strsize);  
	    strncat(new_str,str1, strlen(str1));
	    strncat(new_str,str2, strlen(str2));
	}
	return new_str;
}
