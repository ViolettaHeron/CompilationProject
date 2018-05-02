D                       [0-9]
L                       [a-zA-Z_]
H                       [a-fA-F0-9]
E                       [Ee][+-]?{D}+
FS                      (f|F|l|L)
IS                      (u|U|l|L)*

%{
#include <stdio.h>
#include "y.tab.h"


/* Ne gère pas les commentaires. A rajouter */
/* Supprimer les lignes dont vous n'avez pas besoin. */

%}

%%
"break"                 { return BREAK; }
"case"                  { return CASE; }
"extern"                { return EXTERN; }
"int"                   { return INT; }
"void"                  { return VOID; }
"while"                 { return WHILE; }
"for"                   { return FOR; }
"if"                    { return IF; }
"then"                  { return THEN; }
"else"             		{ return ELSE; }
"switch"                { return SWITCH; }
"default"               { return DEFAULT; }
"return"               	{ return RETURN; }


{L}({L}|{D})*           { /* IDENTIFIER  */ }

{D}+               		{ /* CONSTANTES  */ }


L?\"(\\.|[^\\"])*\"     { /* A completer " */ }

"+="                    { /* A completer */ }
"-="                    { /* A completer */ }
"*="                    { /* A completer */ }
"/="                    { /* A completer */ }
"%="                    { /* A completer */ }
"&="                    { /* A completer */ }
"^="                    { /* A completer */ }
"|="                    { /* A completer */ }

">>"                    { return RSHIFT; }
"<<"                    { return LSHIFT }

"++"                    { /* A completer */ }
"--"                    { /* A completer */ }
"->"                    { /* A completer */ }

"&&"                    { return LAND; }
"||"                    { return LOR }

"<="                    { return LEQ; }
">="                    { return GEQ; }
"=="                    { return EQ; }
"!="                    { return NEQ; }
"!"						{ return NOT; }

[ \t\v\n\f]             { /* A completer */ }
.                       { return yytext[0]; }
%%
