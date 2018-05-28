%{

#include "simple.h"
bool error_syntaxical=false;
bool error_semantical=false;
/* Notre table de hachage */
GHashTable* table_variable;

/* Fonction de suppression des variables declarees a l'interieur d'un arbre syntaxique */
void supprime_variable(GNode*);

/* Notre structure Variable qui a comme membre le type et un pointeur generique vers la valeur */
typedef struct Variable Variable;

struct Variable{
	char* type;
	GNode* value;
};

%}

/*Ici nous avons declare une union avec trois types : nombre de type int, texte de type pointeur de char (char*) et noeud d'arbre syntaxique (AST) de type (GNode*) */

%union {
	long nombre;
	char* texte;
	GNode*	noeud;
}

/* Nous avons ici les operateurs */
%left			TOK_AFFECT
%left			TOK_EQU		TOK_DIFF	TOK_SUP         TOK_INF         TOK_SUPEQU      TOK_INFEQU  TOK_DECD TOK_DECG    /* comparaisons */
%left			TOK_PLUS	TOK_MOINS		/* +- */
%left			TOK_MUL		TOK_DIV		/* /* */
%left			TOK_ET		TOK_OU		TOK_NON		/* et ou non */

%right			TOK_PARG	TOK_PARD	/* () */

/* Nous avons la liste de nos expressions (les non terminaux). Nous les typons tous en noeud de l'arbre syntaxique (GNode*) */

%type<noeud>		code
%type<noeud>		bloc_code
%type<noeud>		instruction
%type<noeud>		condition
%type<noeud>		condition_si
%type<noeud>		condition_sinon
%type<noeud>		variable_arithmetique
%type<noeud>		variable_booleenne
%type<noeud>		affectation
%type<noeud>		affichage
%type<noeud>		expression_arithmetique
%type<noeud>		expression_booleenne
%type<noeud>		addition
%type<noeud>		soustraction
%type<noeud>		multiplication
%type<noeud>		division
%type<noeud>            boucle_for
%type<noeud>            boucle_while
%type<noeud>            variable
%type<noeud>            principal
%type<noeud>		fonction
%type<noeud>		renvoie
%type<noeud>		inclusion
%type<noeud>		caser
%type<noeud>		commentaire

/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token<nombre>          TOK_NOMBRE	
%token                  TOK_VRAI        /* true */
%token                  TOK_FAUX        /* false */
%token                  TOK_ACCOD      /* { */
%token                  TOK_ACCOG      /* } */
%token                  TOK_FINSTR      /* ; */
%token                  TOK_CROG    TOK_CROD    /* [] */
%token                  TOK_AFFICHER    /* afficher */
%token<texte>           TOK_VARB        /* variable booleenne */
%token<texte>           TOK_VARE        /* variable arithmetique */
%token                  TOK_SI          /* si */
%token                  TOK_ALORS       /* alors */
%token                  TOK_SINON       /* sinon */
%token			TOK_TYPEINT	/* int */
%token			TOK_WHILE	/* while */
%token			TOK_FOR		/* for */
%token			TOK_VIRGULE	/* , */
%token 			TOK_MAIN	/* main */
%token 			TOK_RET		/* return */
%token 			TOK_EXT		/* extern */
%token 			TOK_BRK		/* break */
%token 			TOK_SWITCH	/* switch */
%token 			TOK_CASE	/* case */
%token 			TOK_DEFAULT	/* default */
%token			TOK_COMMENT	/*commentaire */


%%

/* Nous definissons toutes les regles grammaticales de chaque non terminal de notre langage.*/

entree:		code{
			genere_code($1);
			g_node_destroy($1);
		};

code: 		%empty{$$=g_node_new((gpointer)CODE_VIDE);}
		|
 		code instruction{
			printf("Resultat : C'est une instruction valide !\n\n");
			$$=g_node_new((gpointer)SEQUENCE);
			g_node_append($$,$1);
			g_node_append($$,$2);
		}
		|
                code commentaire{
                        $$=g_node_new((gpointer)SEQUENCE);
                        g_node_append($$,$1);
                        g_node_append($$,$2);
                }
		|
		code error{
			fprintf(stderr,"\tERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
 			error_syntaxical=true;
		};

commentaire:    TOK_COMMENT{
                                        $$=g_node_new((gpointer)CODE_VIDE);
                                };

bloc_code:	code{
			$$=g_node_new((gpointer)BLOC_CODE);
			g_node_append($$,$1);
			/* supprime_variable($1); */
		};

instruction:	affectation{
			printf("\tInstruction type Affectation\n");
			$$=$1;
 		}
		|
 		affichage{
			printf("\tInstruction type Affichage\n");
			$$=$1;
		}
		|		
		boucle_for{
                        printf("Boucle repetee\n");
                        $$=$1;
                }
                |
                boucle_while{
                        printf("Boucle tant que\n");
                        $$=$1;
                }
		|
		condition{
		    printf("Condition si/sinon\n");
		    $$=$1;
		}
		|
		expression_arithmetique{
		}
		|
		fonction{
			printf("\tFonction :\n");
			$$=$1;
		}
		|
		renvoie{
			printf("\t\t\tReturn \n");
			$$=$1;
		}
		|
		caser{
			printf("\t\t\tBreak \n");
			$$=$1;
		}
		|
		inclusion{
			printf("\t\t\tInclusion \n");
		};

caser:		TOK_BRK TOK_FINSTR{
			$$=g_node_new((gpointer)EXT);
		};

inclusion: 	TOK_EXT TOK_TYPEINT TOK_AFFICHER TOK_PARG TOK_TYPEINT TOK_VARE TOK_PARD TOK_FINSTR{
			$$=g_node_new((gpointer)EXT);
			
		};

renvoie:	TOK_RET instruction TOK_FINSTR{
			$$=g_node_new((gpointer)RET);
			g_node_append($$,$2);
		};

variable_arithmetique:	TOK_VARE{
				printf("\t\t\tVariable entiere %s\n",$1);
				$$=g_node_new((gpointer)VARIABLE);
				g_node_append_data($$,strdup($1));
			};

variable_booleenne:	TOK_VARB{
				printf("\t\t\tVariable booleenne %s\n",$1);
				$$=g_node_new((gpointer)VARIABLE);
				g_node_append_data($$,strdup($1));
			};

fonction: 	 principal TOK_ACCOD{
			printf("\tPrincipal\n");
			$$=g_node_new((gpointer)PRINCIPAL);
			g_node_append($$,$1);
		}
		|

		affectation TOK_PARG affectation TOK_PARD TOK_ACCOG bloc_code TOK_ACCOD{
			printf("\tFonction Secondaire\n");
			$$=g_node_new((gpointer)FONCTION);
			g_node_append($$,$1);
			g_node_append($$,$3);
			g_node_append($$,$6);
		};

principal:	TOK_TYPEINT TOK_MAIN TOK_PARG TOK_PARD TOK_ACCOG bloc_code{
			$$=g_node_new((gpointer)MAIN);
			g_node_append($$,$6);
		};
 
condition:      condition_si{
                    printf("\tCondition si\n");
                    $$=g_node_new((gpointer)CONDITION_SI);
                    g_node_append($$,$1);
                }
                |
                condition_si condition_sinon{
                    printf("\tCondition si/sinon\n");
                    $$=g_node_new((gpointer)CONDITION_SI_SINON);
                    g_node_append($$,$1);
                    g_node_append($$,$2);
                };

condition_si:   TOK_SI expression_booleenne TOK_ACCOG bloc_code TOK_ACCOD{
                    $$=g_node_new((gpointer)SI);
                    g_node_append($$,$2);
                    g_node_append($$,$4);
                }
		|
		TOK_SI expression_booleenne instruction{
                    $$=g_node_new((gpointer)SI);
                    g_node_append($$,$2);
                    g_node_append($$,$3);
		};

condition_sinon:   TOK_SINON bloc_code {
                        $$=g_node_new((gpointer)SINON);
                        g_node_append($$,$2);
                    }
		   |
		   TOK_SINON instruction {
                        $$=g_node_new((gpointer)SINON);
                        g_node_append($$,$2);
                    };

boucle_for:	TOK_FOR TOK_PARG affectation expression_booleenne TOK_FINSTR affectation TOK_PARD instruction {
			$$=g_node_new((gpointer)BOUCLE_FOR);
			g_node_append($$,$3);
			g_node_append($$,$4);
			g_node_append($$,$6);
			g_node_append($$,$8);
		}
		|
		TOK_FOR TOK_PARG affectation expression_booleenne TOK_FINSTR affectation TOK_PARD TOK_ACCOG instruction TOK_ACCOD {
			$$=g_node_new((gpointer)BOUCLE_FOR);
			g_node_append($$,$3);
			g_node_append($$,$4);
			g_node_append($$,$6);
			g_node_append($$,$9);
		};
 
boucle_while:   TOK_WHILE expression_booleenne TOK_ACCOG bloc_code TOK_ACCOD{
			$$=g_node_new((gpointer)BOUCLE_WHILE);
			g_node_append($$,$2);
			g_node_append($$,$4);
		};
variable:	variable_arithmetique{
		printf("\t\tAffectation sur la variable\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				var=malloc(sizeof(Variable));
				if(var!=NULL){
					var->type=strdup("entier");
					/* On l'insere dans la table de hachage (cle: <nom_variable> / valeur: <(type,valeur)>) */
					if(g_hash_table_insert(table_variable,g_node_nth_child($1,0)->data,var)){
    					$$=g_node_new((gpointer)AFFECTATIONE);
    					g_node_append($$,$1);
					}else{
					    fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
					    exit(-1); 
					}
				}else{
					fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
					exit(-1);
				}
			}else{
				fprintf(stderr,"ERREUR - VARIABLE DEJA ALLOUE !\n");
			}
		}
		|
		variable TOK_VIRGULE variable{
			printf("\t\t\t,\n");
			$$=g_node_new((gpointer)VIRGULE);
			g_node_append($$,$1);
			g_node_append($$,$3);
		};

affectation:	TOK_TYPEINT variable TOK_FINSTR{
			printf("\tint\n");
                    	$$=g_node_new((gpointer)AFFECT);
                    	g_node_append($$,$2);
		}
		|
		TOK_TYPEINT variable TOK_CROG expression_arithmetique TOK_CROD TOK_FINSTR{
			printf("\tTableau simple dimension\n");
                    	$$=g_node_new((gpointer)INT_TABLEAUX);
                    	g_node_append($$,$2);
			g_node_append($$,$4);
		}
		|
		variable_arithmetique TOK_CROG expression_arithmetique TOK_CROD TOK_AFFECT variable_arithmetique TOK_CROG expression_arithmetique TOK_CROD TOK_FINSTR{
			printf("\tTableau simple dimension affectation\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				fprintf(stderr,"ERREUR - LA VARIABLE DOIT ETRE ALLOUE !\n");
			}else{	
				Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($6,0)->data);
				if(var==NULL){
					fprintf(stderr,"ERREUR - LA VARIABLE DOIT ETRE ALLOUE !\n");
				}else{
					$$=g_node_new((gpointer)AFFECT_TABLEAUX);
                    			g_node_append($$,$1);
					g_node_append($$,$3);
					g_node_append($$,$6);
					g_node_append($$,$8);
				}
			}
		}
		|
		variable_arithmetique TOK_AFFECT expression_arithmetique TOK_FINSTR{
			printf("\t\tAffectation sur la variable\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				fprintf(stderr,"ERREUR - LA VARIABLE DOIT ETRE ALLOUE !\n");
			}else{
				$$=g_node_new((gpointer)AFFECTATION);
				g_node_append($$,$1);
				g_node_append($$,$3);
			}
		}
		|
		variable_arithmetique TOK_AFFECT expression_arithmetique {
			printf("\t\tAffectation sur la variable\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				fprintf(stderr,"ERREUR - LA VARIABLE DOIT ETRE ALLOUE !\n");
			}else{
				$$=g_node_new((gpointer)AFFECTATION);
				g_node_append($$,$1);
				g_node_append($$,$3);
			}
		}
		|
		variable_booleenne TOK_AFFECT expression_booleenne TOK_FINSTR{
			printf("\t\tAffectation sur la variable\n");
			Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
			if(var==NULL){
				var=malloc(sizeof(Variable));
				if(var!=NULL){
					var->type=strdup("booleen");
					var->value=$3;
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

affichage:	TOK_AFFICHER expression_arithmetique TOK_FINSTR{
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


expression_arithmetique:	TOK_NOMBRE{
					printf("\t\t\tNombre : %ld\n",$1);
					int length=snprintf(NULL,0,"%ld",$1);
					char* str=malloc(length+1);
					snprintf(str,length+1,"%ld",$1);
					$$=g_node_new((gpointer)ENTIER);
					g_node_append_data($$,strdup(str));
					free(str);
				}
				|
				variable_arithmetique{
					Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
					if(var!=NULL){
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
				TOK_PLUS expression_arithmetique{
				    $$=$2;
				}
				|
				expression_arithmetique TOK_DECD expression_arithmetique{
					printf("\t\t\tDecalage a droite\n");
					$$=g_node_new((gpointer)DECD);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_DECG expression_arithmetique{
					printf("\t\t\tDecalage a gauche Non\n");
					$$=g_node_new((gpointer)DECG);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				TOK_MOINS expression_arithmetique{
				    printf("\t\t\tOperation unaire negation\n");
				    $$=g_node_new((gpointer)NEGATIF);
					g_node_append($$,$2);
				}
				|
				TOK_PARG expression_arithmetique TOK_PARD{
					printf("\t\t\tC'est une expression artihmetique entre parentheses\n");
					$$=g_node_new((gpointer)EXPR_PAR);
					g_node_append($$,$2);
				};

expression_booleenne:		TOK_VRAI{
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
					Variable* var=g_hash_table_lookup(table_variable,(char*)g_node_nth_child($1,0)->data);
					if(var!=NULL){
						if(strcmp(var->type,"booleen")==0){
							$$=$1;
						}else{
							fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Type incompatible (booleen attendu - valeur : %s) !\n",lineno,(char*)g_node_nth_child($1,0)->data);
							error_semantical=true;
						}
					}else{
						fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne %d. Variable %s jamais declaree !\n",lineno,(char*)g_node_nth_child($1,0)->data);
						error_semantical=true;
					}
				}
				|
				TOK_NON expression_booleenne{
					printf("\t\t\tOperation booleenne Non\n");
					$$=g_node_new((gpointer)NON);
					g_node_append($$,$2);
				}
				|
				expression_booleenne TOK_ET expression_booleenne{
					printf("\t\t\tOperation booleenne Et\n");
					$$=g_node_new((gpointer)ET);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_booleenne TOK_OU expression_booleenne{
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
				}
				|
				expression_booleenne TOK_EQU expression_booleenne{
					printf("\t\t\tOperateur d'egalite ==\n");
					$$=g_node_new((gpointer)EGALITE);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_booleenne TOK_DIFF expression_booleenne{
					printf("\t\t\tOperateur d'inegalite !=\n");
					$$=g_node_new((gpointer)DIFFERENT);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_EQU expression_arithmetique{
					printf("\t\t\tOperateur d'egalite ==\n");
					$$=g_node_new((gpointer)EGALITE);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_DIFF expression_arithmetique{
					printf("\t\t\tOperateur d'inegalite !=\n");
					$$=g_node_new((gpointer)DIFFERENT);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_SUP expression_arithmetique{
					printf("\t\t\tOperateur de superiorite >\n");
					$$=g_node_new((gpointer)SUPERIEUR);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_INF expression_arithmetique{
					printf("\t\t\tOperateur d'inferiorite <\n");
					$$=g_node_new((gpointer)INFERIEUR);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_SUPEQU expression_arithmetique{
					printf("\t\t\tOperateur >=\n");
					$$=g_node_new((gpointer)SUPEGAL);
					g_node_append($$,$1);
					g_node_append($$,$3);
				}
				|
				expression_arithmetique TOK_INFEQU expression_arithmetique{
					printf("\t\t\tOperateur <=\n");
					$$=g_node_new((gpointer)INFEGAL);
					g_node_append($$,$1);
					g_node_append($$,$3);
				};

addition:	expression_arithmetique TOK_PLUS expression_arithmetique{
    			printf("\t\t\tAddition\n");
    			$$=g_node_new((gpointer)ADDITION);
    			g_node_append($$,$1);
    			g_node_append($$,$3);
    		};

soustraction:	expression_arithmetique TOK_MOINS expression_arithmetique{
        			printf("\t\t\tSoustraction\n");
        			$$=g_node_new((gpointer)SOUSTRACTION);
        			g_node_append($$,$1);
        			g_node_append($$,$3);
        		};

multiplication:	expression_arithmetique TOK_MUL expression_arithmetique{
			printf("\t\t\tMultiplication\n");
			$$=g_node_new((gpointer)MULTIPLICATION);
			g_node_append($$,$1);
			g_node_append($$,$3);
		};

division:	expression_arithmetique TOK_DIV expression_arithmetique{
			printf("\t\t\tDivision\n");
			$$=g_node_new((gpointer)DIVISION);
			g_node_append($$,$1);
			g_node_append($$,$3);
		};

%%


int main(int argc, char** argv){
	char* fichier_entree=strdup(argv[1]);
	stdin=fopen(fichier_entree,"r");
	char* fichier_sortie=strdup(argv[1]);
	strcpy(rindex(fichier_sortie, '.'), "_3d.c");
	fichier=fopen(fichier_sortie, "w");
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
	if(error_lexical||error_syntaxical||error_semantical){
		remove(fichier_sortie);
		printf("ECHEC GENERATION CODE !\n");
	}
	else{
		printf("Le fichier \"%s\" a ete genere !\n",fichier_sortie);
	}
	fclose(fichier);
	fclose(stdin);
	free(fichier_entree);
	free(fichier_sortie);
	g_hash_table_destroy(table_variable);
	return EXIT_SUCCESS;
}

void yyerror(char *s) {
        fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}


void supprime_variable(GNode* ast){
    if(ast&&!G_NODE_IS_LEAF(ast)&&(long)ast->data!=BLOC_CODE){
        if((long)ast->data==AFFECTATIONB||(long)ast->data==AFFECTATIONE){
            if(g_hash_table_remove(table_variable,(char*)g_node_nth_child(g_node_nth_child(ast,0),0)->data)){
                printf("Variable supprimee !\n");
            }else{
                fprintf(stderr,"ERREUR - PROBLEME DE SUPPRESSION VARIABLE !\n");
                exit(-1);
            }
        }else{
            int nb_enfant;
            for(nb_enfant=0;nb_enfant<=g_node_n_children(ast);nb_enfant++){
                supprime_variable(g_node_nth_child(ast,nb_enfant));
            }
        }
    }
}
