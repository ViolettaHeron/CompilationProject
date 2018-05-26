#include "simple.h"

void debut_code(){
	fprintf(fichier, "extern int printd( int i );\n\n");
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
			case BLOC_CODE:
				genere_code(g_node_nth_child(ast,0));
				break;
			case PRINCIPAL:
				genere_code(g_node_nth_child(ast,0));
        			fprintf(fichier,"\n");
        			break;
			case VARIABLE:
				fprintf(fichier,"%s",(char*)g_node_nth_child(ast,0)->data);
				break;
			case AFFECTATIONE:
				fprintf(fichier,"\tint ");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,";\n");
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
				fprintf(fichier,"\tprintd(");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,");\n");
				break;
			case AFFICHAGEB:
				fprintf(fichier,"\tprintd(\"%%s\\n\",");
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
			case MAIN:
				fprintf(fichier, "int main() {\n");
				genere_code(g_node_nth_child(ast,0));
				fprintf(fichier,"\t}\n");
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
		}
	}
}
