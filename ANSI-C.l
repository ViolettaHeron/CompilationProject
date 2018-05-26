%{
#include "simple.h"
unsigned int lineno=1;
bool error_lexical=false;

	/* Ne gère pas les commentaires. A rajouter */
	/* Supprimer les lignes dont vous n"avez pas besoin. */

	/*
	COMMANDS TO RUN

	bison -d -v cfe.y && flex ANSI-C.l && gcc lex.yy.c cfe.tab.c -o outputFile -ll && ./outputFile < Tests/add.c

	note : Doublequotes needed
	
	*/
%}
%option noyywrap
nombre 0|[1-9][[:digit:]]*
variable_arithmetique ([[:alnum:]])*
%%

{nombre} {
        sscanf(yytext, "%ld", &yylval.nombre);
        return TOK_NOMBRE;
}
"int"                   { return TOK_TYPEINT ; }
"printd"		{ return TOK_AFFICHER; }
";"             	{ return TOK_FINSTR; }
"="             	{ return TOK_AFFECT; }
"true"          	{ return TOK_VRAI; }
"false"          	{ return TOK_FAUX; }
"+" 			{ return TOK_PLUS; }
"-" 			{ return TOK_MOINS; }
"*" 			{ return TOK_MUL; }
"/" 			{ return TOK_DIV; }
"("             	{ return TOK_PARG;}
")"             	{ return TOK_PARD;}
"&" 			{ return TOK_BAND; }
"|" 			{ return TOK_BOR; }
"not"			{ return TOK_NOT;}
"{"			{ return TOK_ACCOLADEG;}
"}"			{ return TOK_ACCOLADED;}
"main"			{ return TOK_MAIN;}
"=="			{ return TOK_EQ; }
"!="                    { return TOK_NEQ; }
">" 			{ return TOK_GT; }
"<" 			{ return TOK_LT; }
"<="			{ return TOK_LEQ; }
">="			{ return TOK_GEQ; }

{variable_arithmetique} {
        yylval.texte = yytext;
  	return TOK_VARE;
}


 /*
"break"                 { return TOK_BREAK; }
"case"                  { return TOK_CASE; }
"extern"                { return TOK_EXTERN; }
"void"                  { return TOK_VOID; }
"while"                 { return TOK_WHILE; }
"for"                   { return TOK_FOR; }
"if"                    { return TOK_IF; }
"then"                  { return TOK_THEN; }
"else"             	{ return TOK_ELSE; }
"switch"                { return TOK_SWITCH; }
"default"               { return TOK_DEFAULT; }
"return"               	{ return TOK_RETURN; }
">>"                    { return TOK_RSHIFT; }
"<<"                    { return TOK_LSHIFT; }

"&&"                    { return TOK_LAND; }
"||"                    { return TOK_LOR; }
 */

%%
