%{
	#include "simple.h"
	bool error_syntaxical=false;
	bool error_semantical=false;
	/* Notre table de hachage */
	GHashTable* table_variable;
	
	/* Notre structure Variable qui a comme membre le type et un pointeur generique vers la valeur */
	typedef struct Variable Variable;

	struct Variable{
        char* type;
        GNode* value;
	};

%}

/* L'union dans Bison est utilisee pour typer nos tokens ainsi que nos non terminaux. Ici nous avons declare une union avec trois types : nombre de type int, texte de type pointeur de char (char*) et noeud d'arbre syntaxique (AST) de type (GNode*) */
%union {
        long nombre;
        char* texte;
        GNode*  noeud;
}

/* Nous avons ici les operateurs, ils sont definis par leur ordre de priorite. Si je definis par exemple la multiplication en premier et l'addition apres, le + l'emportera alors sur le * dans le langage. Les parenthese sont prioritaires avec %right */
%left 			TOK_PLUS 		TOK_MOINS			/* +-*/
%left 			TOK_MUL 		TOK_DIV				/* /* */
%left 			TOK_BAND						/* et  */
%left 			TOK_BOR 		TOK_NOT				/* simble "ou" et not) */	
%right                  TOK_PARG        	TOK_PARD 			/* ()  */

/* Nous avons la liste de nos expressions (les non terminaux). Nous les typons tous en noeud de l'arbre syntaxique (GNode*) */

%type<noeud>            code
%type<noeud>            instruction
%type<noeud>            variable_arithmetique
%type<noeud>            variable_booleenne
%type<noeud>            affectation
%type<noeud>            affichage
%type<noeud>            expression_arithmetique
%type<noeud>            expression_booleenne
%type<noeud>            addition
%type<noeud>            soustraction
%type<noeud>            multiplication
%type<noeud>            division

/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token<nombre>          TOK_NOMBRE
%token			TOK_VRAI	/* true */
%token			TOK_FAUX	/* false */
%token			TOK_TYPEINT 	/* int */
%token			TOK_AFFECT	/* = */
%token			TOK_FINSTR	/* ; */
%token			TOK_AFFICHER	/* afficher */
%token<texte>           TOK_VARE        /* variable arithmetique */
%token<texte> 		TOK_VARB	/* variable booleenne */


%%

/* Nous definissons toutes les regles grammaticales de chaque non terminal de notre langage. Par defaut on commence a definir l'axiome, c'est a dire ici le non terminal code. Si nous le definissons pas en premier nous devons le specifier en option dans Bison avec %start */
 
entree:         code{
                        genere_code($1);
                        g_node_destroy($1);
                };
 
code:           %empty{$$=g_node_new((gpointer)CODE_VIDE);}
                |
                code instruction{
                        printf("Resultat : C'est une instruction valide !\n\n");
                        $$=g_node_new((gpointer)SEQUENCE);
                        g_node_append($$,$1);
                        g_node_append($$,$2);
                }
                |
                code error{
                        fprintf(stderr,"\tERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
                        error_syntaxical=true;
                };
 
instruction:    affectation{
                        printf("\tInstruction type Affectation\n");
                        $$=$1;
                }
                |
                affichage{
                        printf("\tInstruction type Affichage\n");
                        $$=$1;
                };
 
variable_arithmetique:  TOK_VARE{
                                printf("\t\t\tVariable entiere %s\n",$1);
                                $$=g_node_new((gpointer)VARIABLE);
                                g_node_append_data($$,strdup($1));
                        };
 
variable_booleenne:     TOK_VARB{
                                printf("\t\t\tVariable booleenne %s\n",$1);
                                $$=g_node_new((gpointer)VARIABLE);
                                g_node_append_data($$,strdup($1));
                        };
 
affectation:    
		TOK_TYPEINT variable_arithmetique TOK_FINSTR{
                        /* $1 est la valeur du premier non terminal. Ici c'est la valeur du non terminal variable. $3 est la valeur du 2nd non terminal. */
                        printf("\t\tAllocation sur la variable\n");
                        Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($2,0)->data);
                        if(var==NULL){
                                /* On cree une Variable et on lui affecte le type que nous connaissons et la valeur */
                                var=malloc(sizeof(Variable));
                                if(var!=NULL){
                                        var->type=strdup("entier");
                                        /* On l'insere dans la table de hachage (cle: <nom_variable> / valeur: <(type,valeur)>) */
                                        if(g_hash_table_insert(table_variable,g_node_nth_child($2,0)->data,var)){
                                                $$=g_node_new((gpointer)AFFECTATIONE);
                                                g_node_append($$,$2);
                                        }else{
                                                fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
                                                exit(-1);
                                        }
                                }else{
                                        fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
                                        exit(-1);
                                }
                        }else{
                                fprintf(stderr,"ERREUR - PROBLEME VARIABLE DEJA DECLARE !\n");
                                exit(-1);
                        }
                }
		|
		variable_arithmetique TOK_AFFECT expression_arithmetique TOK_FINSTR{
			printf("\t\tAffectation sur la variable\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				fprintf(stderr,"ERREUR - PROBLEME VARIABLE NON DECLAREE !\n");
                                exit(-1);
			}else{
				var->value=$3;
				$$=g_node_new((gpointer)AFFECTATION);
                                g_node_append($$,$1);
                                g_node_append($$,$3);
			}
		}
                |
                variable_booleenne TOK_AFFECT expression_booleenne TOK_FINSTR{
                        /* $1 est la valeur du premier non terminal. Ici c'est la valeur du non terminal variable. $3 est la valeur du 2nd non terminal. */
                        printf("\t\tAffectation sur la variable\n");
                        Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
                        if(var==NULL){
                                /* On cree une Variable et on lui affecte le type que nous connaissons et la valeur */
                                var=malloc(sizeof(Variable));
                                if(var!=NULL){
                                        var->type=strdup("booleen");
                                        var->value=$3;
                                        /* On l'insere dans la table de hachage (cle: <nom_variable> / valeur: <(type,valeur)>) */
                                        if(g_hash_table_insert(table_variable,g_node_nth_child($1,0)->data,var)){
                                                $$=g_node_new((gpointer)AFFECTATIONB);
                                                g_node_append($$,$1);
                                                g_node_append($$,$3);
                                        }else{
                                                fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
                                                exit(-1);
                                        }
                                }else{
                                        fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
                                        exit(-1);
                                }
                        }else{
                                $$=g_node_new((gpointer)AFFECTATION);
                                g_node_append($$,$1);
                                g_node_append($$,$3);
                        }
                };
 
affichage:      TOK_AFFICHER expression_arithmetique TOK_FINSTR{
                        printf("\t\tAffichage de la valeur de l'expression arithmetique\n");
                        $$=g_node_new((gpointer)AFFICHAGEE);
                        g_node_append($$,$2);
                }
                |
                TOK_AFFICHER expression_booleenne TOK_FINSTR{
                        printf("\t\tAffichage de la valeur de l'expression booleenne\n");
                        $$=g_node_new((gpointer)AFFICHAGEB);
                        g_node_append($$,$2);
                };
 
 
expression_arithmetique:        TOK_NOMBRE{
                                        printf("\t\t\tNombre : %ld\n",$1);
                                        /* Comme le token TOK_NOMBRE est de type entier et que on a type expression_arithmetique comme du texte, il nous faut convertir la valeur en texte. */
                                        int length=snprintf(NULL,0,"%ld",$1);
                                        char* str=malloc(length+1);
                                        snprintf(str,length+1,"%ld",$1);
                                        $$=g_node_new((gpointer)ENTIER);
                                        g_node_append_data($$,strdup(str));
                                        free(str);
                                }
                                |
                                variable_arithmetique{
                                        /* On recupere un pointeur vers la structure Variable */
                                        Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
                                        /* Si on a trouve un pointeur valable */
                                        if(var!=NULL){
                                                /* On verifie que le type est bien un entier - Inutile car impose a l'analyse syntaxique */
                                                if(strcmp(var->type,"entier")==0){
                                                        $$=$1;
                                                }else{
                                                        fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Type incompatible (entier attendu - valeur : %s) !\n",lineno,(char*)g_node_nth_child($1,0)->data);
                                                        error_semantical=true;
                                                }
                                        /* Sinon on conclue que la variable n'a jamais ete declaree car absente de la table */
                                        }else{
                                                fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Variable %s jamais declaree !\n",lineno,(char*)g_node_nth_child($1,0)->data);
                                                error_semantical=true;
                                        }
                                }
                                |
                                addition{
                                        $$=$1;
                                }
                                |
                                soustraction{
                                        $$=$1;
                                }
                                |
                                multiplication{
                                        $$=$1;
                                }
                                |
                                division{
                                        $$=$1;
                                }
                                |
                                TOK_PARG expression_arithmetique TOK_PARD{
                                        printf("\t\t\tC'est une expression artihmetique entre parentheses\n");
                                        $$=g_node_new((gpointer)EXPR_PAR);
                                        g_node_append($$,$2);
                                };
 
expression_booleenne:           TOK_VRAI{
                                        printf("\t\t\tBooleen Vrai\n");
                                        $$=g_node_new((gpointer)VRAI);
                                }
                                |
                                TOK_FAUX{
                                        printf("\t\t\tBooleen Faux\n");
                                        $$=g_node_new((gpointer)FAUX);
                                }
                                |
                                variable_booleenne{
                                        /* On recupere un pointeur vers la structure Variable */
                                        Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
                                        /* Si on a trouve un pointeur valable */
                                        if(var!=NULL){
                                                /* On verifie que le type est bien un entier - Inutile car impose a l'analyse syntaxique */
                                                if(strcmp(var->type,"booleen")==0){
                                                        $$=$1;
                                                }else{
                                                        fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Type incompatible (booleen attendu - valeur : %s) !\n",lineno,(char*)g_node_nth_child($1,0)->data);
                                                        error_semantical=true;
                                                }
                                        /* Sinon on conclue que la variable n'a jamais ete declaree car absente de la table */
                                        }else{
                                                fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Variable %s jamais declaree !\n",lineno,(char*)g_node_nth_child($1,0)->data);
                                                error_semantical=true;
                                        }
                                }
                                |
                                TOK_NOT expression_booleenne{
                                        printf("\t\t\tOperation booleenne Non\n");
                                        $$=g_node_new((gpointer)NON);
                                        g_node_append($$,$2);
                                }
                                |
                                expression_booleenne TOK_BAND expression_booleenne{
                                        printf("\t\t\tOperation booleenne Et\n");
                                        $$=g_node_new((gpointer)ET);
                                        g_node_append($$,$1);
                                        g_node_append($$,$3);
                                }
                                |
                                expression_booleenne TOK_BOR expression_booleenne{
                                        printf("\t\t\tOperation booleenne Ou\n");
                                        $$=g_node_new((gpointer)OU);
                                        g_node_append($$,$1);
                                        g_node_append($$,$3);
                                }
                                |
                                TOK_PARG expression_booleenne TOK_PARD{
                                        printf("\t\t\tC'est une expression booleenne entre parentheses\n");
                                        $$=g_node_new((gpointer)EXPR_PAR);
                                        g_node_append($$,$2);
                                };
 
addition:       expression_arithmetique TOK_PLUS expression_arithmetique{
                        printf("\t\t\tAddition\n");
                        $$=g_node_new((gpointer)ADDITION);
                        g_node_append($$,$1);
                        g_node_append($$,$3);
                };
 
soustraction:   expression_arithmetique TOK_MOINS expression_arithmetique{
                        printf("\t\t\tSoustraction\n");
                        $$=g_node_new((gpointer)SOUSTRACTION);
                        g_node_append($$,$1);
                        g_node_append($$,$3);
                };
 
multiplication: expression_arithmetique TOK_MUL expression_arithmetique{
                        printf("\t\t\tMultiplication\n");
                        $$=g_node_new((gpointer)MULTIPLICATION);
                        g_node_append($$,$1);
                        g_node_append($$,$3);
                };
 
division:       expression_arithmetique TOK_DIV expression_arithmetique{
                        printf("\t\t\tDivision\n");
                        $$=g_node_new((gpointer)DIVISION);
                        g_node_append($$,$1);
                        g_node_append($$,$3);
                };
 
%%
 
/* Dans la fonction main on appelle bien la routine yyparse() qui sera genere par Bison. Cette routine appellera yylex() de notre analyseur lexical. */
 
int main(int argc, char** argv){
        /* recuperation du nom de fichier d'entree (langage Simple) donne en parametre */
        char* fichier_entree=strdup(argv[1]);
        /* ouverture du fichier en lecture dans le flux d'entree stdin */
        stdin=fopen(fichier_entree,"r");
        /* creation fichier de sortie (langage C) */
        char* fichier_sortie=strdup(argv[1]);
        /* remplace l'extension par .c */
        strcpy(rindex(fichier_sortie, '.'), ".c");
        /* ouvre le fichier cree en ecriture */
        fichier=fopen(fichier_sortie, "w");
        /* Creation de la table de hachage */
        table_variable=g_hash_table_new_full(g_str_hash,g_str_equal,free,free);
        printf("Debut de l'analyse syntaxique :\n");
        debut_code();
        yyparse();
        fin_code();
        printf("Fin de l'analyse !\n");
        printf("Resultat :\n");
        if(error_lexical){
                printf("\t-- Echec : Certains lexemes ne font pas partie du lexique du langage ! --\n");
                printf("\t-- Echec a l'analyse lexicale --\n");
        }
        else{
                printf("\t-- Succes a l'analyse lexicale ! --\n");
        }
        if(error_syntaxical){
                printf("\t-- Echec : Certaines phrases sont syntaxiquement incorrectes ! --\n");
                printf("\t-- Echec a l'analyse syntaxique --\n");
        }
        else{
                printf("\t-- Succes a l'analyse syntaxique ! --\n");
                if(error_semantical){
                        printf("\t-- Echec : Certaines phrases sont semantiquement incorrectes ! --\n");
                        printf("\t-- Echec a l'analyse semantique --\n");
                }
                else{
                        printf("\t-- Succes a l'analyse semantique ! --\n");
                }
        }
        /* Suppression du fichier genere si erreurs analyse */
        if(error_lexical||error_syntaxical||error_semantical){
                remove(fichier_sortie);
                printf("ECHEC GENERATION CODE !\n");
        }
        else{
                printf("Le fichier \"%s\" a ete genere !\n",fichier_sortie);
        }
        /* Fermeture des flux */
        fclose(fichier);
        fclose(stdin);
        /* Liberation memoire */
        free(fichier_entree);
        free(fichier_sortie);
        g_hash_table_destroy(table_variable);
        return EXIT_SUCCESS;
}
 
void yyerror(char *s) {
        fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}
/*
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
*/
