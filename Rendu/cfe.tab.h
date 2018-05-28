/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_CFE_TAB_H_INCLUDED
# define YY_YY_CFE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_AFFECT = 258,
    TOK_EQU = 259,
    TOK_DIFF = 260,
    TOK_SUP = 261,
    TOK_INF = 262,
    TOK_SUPEQU = 263,
    TOK_INFEQU = 264,
    TOK_DECD = 265,
    TOK_DECG = 266,
    TOK_PLUS = 267,
    TOK_MOINS = 268,
    TOK_MUL = 269,
    TOK_DIV = 270,
    TOK_ET = 271,
    TOK_OU = 272,
    TOK_NON = 273,
    TOK_PARG = 274,
    TOK_PARD = 275,
    TOK_NOMBRE = 276,
    TOK_VRAI = 277,
    TOK_FAUX = 278,
    TOK_ACCOD = 279,
    TOK_ACCOG = 280,
    TOK_FINSTR = 281,
    TOK_CROG = 282,
    TOK_CROD = 283,
    TOK_AFFICHER = 284,
    TOK_VARB = 285,
    TOK_VARE = 286,
    TOK_SI = 287,
    TOK_ALORS = 288,
    TOK_SINON = 289,
    TOK_TYPEINT = 290,
    TOK_WHILE = 291,
    TOK_FOR = 292,
    TOK_VIRGULE = 293,
    TOK_MAIN = 294,
    TOK_RET = 295,
    TOK_EXT = 296,
    TOK_BRK = 297,
    TOK_SWITCH = 298,
    TOK_CASE = 299,
    TOK_DEFAULT = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 24 "cfe.y" /* yacc.c:1909  */

	long nombre;
	char* texte;
	GNode*	noeud;

#line 106 "cfe.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_CFE_TAB_H_INCLUDED  */
