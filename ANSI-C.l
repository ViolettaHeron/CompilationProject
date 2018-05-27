%{

#include "simple.h"
unsigned int lineno=1;
bool error_lexical=false;

%}

%option noyywrap

nombre 0|[1-9][[:digit:]]*
variable_booleenne b(_|[[:alnum:]])*
variable_arithmetique ([[:alnum:]])*

%%

{nombre} {
    sscanf(yytext, "%ld", &yylval.nombre);
    return TOK_NOMBRE;
}
"for"		{return TOK_FOR;}

"while"		{return TOK_WHILE;}

"if"    	{return TOK_SI;}
     
"alors" 	{return TOK_ALORS;}
     
"else" 		{return TOK_SINON;}

"=="        	{return TOK_EQU;}

"!="           	{return TOK_DIFF;}

">"  		{return TOK_SUP;}

"<"  		{return TOK_INF;}

">="          	{return TOK_SUPEQU;}

"<="          	{return TOK_INFEQU;}

"compris dans"|"dans"               {return TOK_IN;}

"int"         	{ return TOK_TYPEINT ; }

"printd"      {return TOK_AFFICHER;}

"="             {return TOK_AFFECT;}

"+"             {return TOK_PLUS;}

"-"             {return TOK_MOINS;}

"*"             {return TOK_MUL;}

"/"             {return TOK_DIV;}

"("             {return TOK_PARG;}

")"             {return TOK_PARD;}

"{"             {return TOK_ACCOG;}

"}"             {return TOK_ACCOD;}

"["             {return TOK_CROG;}

"]"             {return TOK_CROD;}

"et"            {return TOK_ET;}

"ou"            {return TOK_OU;}

"non"           {return TOK_NON;}

";"             {return TOK_FINSTR;}

","             {return TOK_VIRGULE;}

"vrai"          {return TOK_VRAI;}

"faux"          {return TOK_FAUX;}

"main"          {return TOK_MAIN;}

"return"        {return TOK_RET;}

"extern"        {return TOK_EXT;}

"\n"            {lineno++;}

{variable_booleenne} {
    yylval.texte = yytext;
    return TOK_VARB;
}


{variable_arithmetique} {
    yylval.texte = yytext;
    return TOK_VARE;
}

" "|"\t" {}

. {
    fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne %d. Il s'agit de %s et comporte %d lettre(s)\n",lineno,yytext,yyleng);
    error_lexical=true;
    return yytext[0];
}

%%
