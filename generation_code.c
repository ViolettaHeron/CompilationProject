#include "simple.h"
unsigned int NB_BOUCLE=0;
void debut_code(){
	fprintf(fichier, "/* FICHIER GENERE PAR LE COMPILATEUR MONGCC */\n\n");
	fprintf(fichier, "#include<stdlib.h>\n#include<stdbool.h>\n#include<stdio.h>\n\n");
}

void fin_code(){
}

void genere_code(GNode* ast){
	if(ast){
		switch((long)ast->data){
			case SEQUENCE:
				genere_code(g_node_nth_child(ast,0));
				genere_code(g_node_nth_child(ast,1));
				break;
			case VARIABLE:
				fprintf(fichier,"%s",(char*)g_node_nth_child(ast,0)->data);
				break;
			case AFFECTATIONE:
				fprintf(fichier,"\tint ");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,";\n");
				break;
			case AFFECT:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"");
				break;
			case VIRGULE:
				genere_code(g_node_nth_child(ast,0));
				genere_code(g_node_nth_child(ast,1));
				break;
			case AFFECTATIONB:
				fprintf(fichier,"\tbool ");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"=");
				genere_code(g_node_nth_child(ast,1));
				fprintf(fichier,";\n");
				break;
			case AFFECTATION:
				fprintf(fichier,"\t");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"=");
				genere_code(g_node_nth_child(ast,1));
				fprintf(fichier,";\n");
				break;
			case AFFICHAGEE:
				fprintf(fichier,"\tprintf(\"%%ld\\n\",");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,");\n");
				break;
			case AFFICHAGEB:
				fprintf(fichier,"\tprintf(\"%%s\\n\",");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"?\"vrai\":\"faux\");\n");
				break;
			case ENTIER:
				fprintf(fichier,"%s",(char*)g_node_nth_child(ast,0)->data);
				break;
			case ADDITION:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"+");
				genere_code(g_node_nth_child(ast,1));
				break;
			case SOUSTRACTION:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"-");
				genere_code(g_node_nth_child(ast,1));
				break;
			case MULTIPLICATION:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"*");
				genere_code(g_node_nth_child(ast,1));
				break;
			case DIVISION:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"/");
				genere_code(g_node_nth_child(ast,1));
				break;
			case VRAI:
				fprintf(fichier,"true");
				break;
			case FAUX:
				fprintf(fichier,"false");
				break;
			case ET:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"&&");
				genere_code(g_node_nth_child(ast,1));
				break;
			case OU:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"||");
				genere_code(g_node_nth_child(ast,1));
				break;
			case NON:
				fprintf(fichier,"!");
				genere_code(g_node_nth_child(ast,0));
				break;
			case EXPR_PAR:
				fprintf(fichier,"(");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,")");
				break;
		    	case EGALITE:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"==");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case DIFFERENT:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"!=");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case INFERIEUR:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case SUPERIEUR:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case INFEGAL:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<=");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case SUPEGAL:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">=");
			    	genere_code(g_node_nth_child(ast,1));
			    	break;
		    	case DANSII:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">=");
			    	genere_code(g_node_nth_child(ast,1));
			    	fprintf(fichier,"&&");
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<=");
			    	genere_code(g_node_nth_child(ast,2));
			    	break;
		    	case DANSEI:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">");
			    	genere_code(g_node_nth_child(ast,1));
			    	fprintf(fichier,"&&");
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<=");
			    	genere_code(g_node_nth_child(ast,2));
			    	break;
		    	case DANSIE:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">=");
			    	genere_code(g_node_nth_child(ast,1));
			    	fprintf(fichier,"&&");
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<");
			    	genere_code(g_node_nth_child(ast,2));
			   	break;
		    	case DANSEE:
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,">");
			    	genere_code(g_node_nth_child(ast,1));
			    	fprintf(fichier,"&&");
			    	genere_code(g_node_nth_child(ast,0));
			    	fprintf(fichier,"<");
			   	genere_code(g_node_nth_child(ast,2));
			    	break;
			case NEGATIF:
				fprintf(fichier,"-");
				genere_code(g_node_nth_child(ast,0));
				break;
			case CONDITION_SI:
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"\n");
				break;
			case CONDITION_SI_SINON:
				genere_code(g_node_nth_child(ast,0));
				genere_code(g_node_nth_child(ast,1));
				break;
			case SI:
				fprintf(fichier,"\tif(");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"){\n");
				genere_code(g_node_nth_child(ast,1));
				fprintf(fichier,"\t}");
				break;
			case SINON:
				fprintf(fichier,"else{\n");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"\t}\n");
				break;
    			case BLOC_CODE:
           			genere_code(g_node_nth_child(ast,0));
            			break;
			case BOUCLE_FOR:
                                fprintf(fichier,"\tfor(");
                                genere_code(g_node_nth_child(ast,0));
                                fprintf(fichier,"\t){\n");
				genere_code(g_node_nth_child(ast,1));
                                fprintf(fichier,"\t}\n");
                                break;
                        case BOUCLE_WHILE:
                                fprintf(fichier,"\twhile(");
                                genere_code(g_node_nth_child(ast,0));
                                fprintf(fichier,"){\n");
                                genere_code(g_node_nth_child(ast,1));
                                fprintf(fichier,"\t}\n");
                                break;
			case PRINCIPAL:
				genere_code(g_node_nth_child(ast,0));
        			fprintf(fichier,"\n");
        			break;
			case MAIN:
				fprintf(fichier, "int main() {\n");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"\t}\n");
				break;
			case RET:
				fprintf(fichier,"\treturn ");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,";\n");
				break;
			case EXT:
				fprintf(fichier, "extern int printd( int i );\n\n");
				break;
			}
	}
}
