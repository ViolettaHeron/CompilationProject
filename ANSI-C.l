D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*



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
%x IN_COMMENT

nombre 0|[1-9][[:digit:]]*
variable_booleenne b(_|[[:alnum:]])*
variable_arithmetique e(_|[[:alnum:]])*
%%

{nombre} {
        sscanf(yytext, "%ld", &yylval.nombre);
        return TOK_NOMBRE;
}

"break"                 { return TOK_BREAK; }
"case"                  { return TOK_CASE; }
"extern"                { return TOK_EXTERN; }
"int"                   { return TOK_INT; }
"void"                  { return TOK_VOID; }
"while"                 { return TOK_WHILE; }
"for"                   { return TOK_FOR; }
"if"                    { return TOK_IF; }
"then"                  { return TOK_THEN; }
"else"             	{ return TOK_ELSE; }
"switch"                { return TOK_SWITCH; }
"default"               { return TOK_DEFAULT; }
"return"               	{ return TOK_RETURN; }
"printd"		{ return TOK_AFFICHER; }
";"             	{ return TOK_FINSTR; }
"="             	{ return TOK_AFFECT; }
"true"          	{ return TOK_VRAI; }
"false"          	{ return TOK_FAUX; }

{L}({L}|{D})*           { yylval.nom_id = malloc(sizeof(yytext)); strncpy(yylval.nom_id, yytext,strlen(yytext)); return IDENTIFICATEUR; }
{D}+               		{ yylval.valeur = atoi(yytext); return TOK_CONSTANTE; }

<INITIAL>{
	"/*"  				{  BEGIN(IN_COMMENT); }
}
<IN_COMMENT>{
	"*/"  				{ BEGIN(INITIAL); }
	[^*\n]+             // eat comment in chunks
	"*"                 // eat the lone star
	\n                  yylineno++;
}

">>"                    { return TOK_RSHIFT; }
"<<"                    { return TOK_LSHIFT; }

"&&"                    { return TOK_LAND; }
"||"                    { return TOK_LOR; }

"<="			{ return TOK_LEQ; }
">="			{ return TOK_GEQ; }
"=="			{ return TOK_EQ; }
"!="                    { return TOK_NEQ; }
"!"			{ return TOK_NOT; }

"+" 			{ return TOK_PLUS; }
"-" 			{ return TOK_MOINS; }
"*" 			{ return TOK_MUL; }
"/" 			{ return TOK_DIV; }
"("             	{ return TOK_PARG;}
")"             	{ return TOK_PARD;}
"&" 			{ return TOK_BAND; }
"|" 			{ return TOK_BOR; }
"<" 			{ return TOK_LT; }
">" 			{ return TOK_GT; }

[ \t\v\n\f]             { /* A completer */ }

{variable_booleenne} {
        yylval.texte = yytext;
        return TOK_VARB;
}
 
 
{variable_arithmetique} {
        yylval.texte = yytext;
  	return TOK_VARE;
}

.{
        fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne %d. Il s'agit de %s et comporte %d 	lettre(s)\n",lineno,yytext,yyleng);
        error_lexical=true;
        return yytext[0];
}
%%
