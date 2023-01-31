alpha 			[A-Za-z_]
fl			(f|F|l|L)
ul			(u|U|l|L)*
digit 			[0-9]
space 			[ ]
hex			[a-fA-F0-9]
exp			[Ee][+-]?{digit}+

%{

char datatype[100] = "dummy";
int tl;  //text line
char next;
#include <stdio.h>
#include <string.h> 

%}

%%	
\n   					{ yylineno++; }
"/*"					{ multicomment(); }
"//"					{ singlecomment(); }

"#include<"({alpha})*".h>" 		{}

"#define"({space})""({alpha})""({alpha}|{digit})*""({space})""({digit})+"" 			{insertToHash(yytext,"MOT RESERVE",yylineno); return DEFINE;}


{digit}+    				{  insertToConstTable(yytext, yylineno, "INT"); return CONSTANT; }
({digit}+)\.({digit}+) 			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
0[xX]{hex}+{ul}?			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{ul}?				{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
'(\\.|[^\\'])+'				{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{exp}{fl}?			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+"."{digit}*({exp})?{fl}?	{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{alpha}?\"(\\.|[^\\"])*\"		{  insertToConstTable(yytext, yylineno, "STRING"); return STRING_LITERAL; } 

"->"			{  insertToHash(yytext,"OPERATOR",yylineno);return PTR_OP; }
"++"			{  insertToHash(yytext,"OPERATOR",yylineno);return INC_OP; }
"--"			{  insertToHash(yytext,"OPERATOR",yylineno);return DEC_OP; }
"<<"			{  insertToHash(yytext,"OPERATOR",yylineno);return LEFT_OP; }
">>"			{  insertToHash(yytext,"OPERATOR",yylineno);return RIGHT_OP; }
"<="			{  insertToHash(yytext,"OPERATOR",yylineno);return LE_OP; }
">="			{  insertToHash(yytext,"OPERATOR",yylineno);return GE_OP; }
"=="			{  insertToHash(yytext,"OPERATOR",yylineno);return EQ_OP; }
"!="			{  insertToHash(yytext,"OPERATOR",yylineno);return NE_OP; }
"&&"			{  insertToHash(yytext,"OPERATOR",yylineno);return AND_OP; }
"||"			{  insertToHash(yytext,"OPERATOR",yylineno);return OR_OP; }
"*="			{  insertToHash(yytext,"OPERATOR",yylineno);return MUL_ASSIGN; }
"/="			{  insertToHash(yytext,"OPERATOR",yylineno);return DIV_ASSIGN; }
"%="			{  insertToHash(yytext,"OPERATOR",yylineno);return MOD_ASSIGN; }
"+="			{  insertToHash(yytext,"OPERATOR",yylineno);return ADD_ASSIGN; }
"-="			{  insertToHash(yytext,"OPERATOR",yylineno);return SUB_ASSIGN; }



"break"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return BREAK; }
"case"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return CASE; }
"char"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return CHAR; }
"const"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return CONST; }
"continue"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return CONTINUE; }
"default"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return DEFAULT; }
"do"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return DO; }
"double"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return DOUBLE; }
"else"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return ELSE; }
"enum"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return ENUM; }

"float"			{ strcpy(datatype, "FLOAT"); tl = yylineno;insertToHash(yytext,"MOT RESERVE",yylineno); return FLOAT; }
"for"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return FOR; }

"if"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return IF; }
"int"			{ strcpy(datatype, "INT"); tl = yylineno;insertToHash(yytext,"MOT RESERVE",yylineno); return INT; }
"long"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return LONG; }

"return"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return RETURN; }
"short"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return SHORT; }
"signed"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return SIGNED; }
"sizeof" 		{ insertToHash(yytext,"MOT RESERVE",yylineno);return SIZEOF; }
"static"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return STATIC; }
"struct"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return STRUCT; }
"switch"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return SWITCH; }
"typedef"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return TYPEDEF; }
"union"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return UNION; }
"unsigned"		{ insertToHash(yytext,"MOT RESERVE",yylineno);return UNSIGNED; }
"void"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return VOID; }

"while"			{ insertToHash(yytext,"MOT RESERVE",yylineno);return WHILE; }


";"			{  strcpy(datatype, "dummy");insertToHash(yytext,"PONCTUATION",yylineno); return(';'); }
("{")			{  insertToHash(yytext,"PONCTUATION",yylineno);return('{'); }
("}")			{  insertToHash(yytext,"PONCTUATION",yylineno);return('}'); }
","			{  insertToHash(yytext,"PONCTUATION",yylineno);return(','); }
":"			{  insertToHash(yytext,"PONCTUATION",yylineno);return(':'); }
"="			{  insertToHash(yytext,"OPERATOR",yylineno);return('='); }
"("			{  insertToHash(yytext,"PONCTUATION",yylineno);return('('); }
")"			{  insertToHash(yytext,"PONCTUATION",yylineno);return(')'); }
("[")			{  insertToHash(yytext,"PONCTUATION",yylineno);return('['); }
("]")			{  insertToHash(yytext,"PONCTUATION",yylineno);return(']'); }
"."			{  insertToHash(yytext,"PONCTUATION",yylineno);return('.'); }
"&"			{  insertToHash(yytext,"OPERATOR",yylineno);return('&'); }
"!"			{  insertToHash(yytext,"OPERATOR",yylineno);return('!'); }
"~"			{  insertToHash(yytext,"OPERATOR",yylineno);return('~'); }
"-"			{  insertToHash(yytext,"OPERATOR",yylineno);return('-'); }
"+"			{  insertToHash(yytext,"OPERATOR",yylineno);return('+'); }
"*"			{  insertToHash(yytext,"OPERATOR",yylineno);return('*'); }
"/"			{  insertToHash(yytext,"OPERATOR",yylineno);return('/'); }
"%"			{  insertToHash(yytext,"OPERATOR",yylineno);return('%'); }
"<"			{  insertToHash(yytext,"BIOPERATOR",yylineno);return('<'); }
">"			{  insertToHash(yytext,"BIOPERATOR",yylineno);return('>'); }
"^"			{  insertToHash(yytext,"OPERATOR",yylineno);return('^'); }
"|"			{  insertToHash(yytext,"BIOPERATOR",yylineno);return('|'); }
"?"			{  insertToHash(yytext,"OPERATOR",yylineno);return('?'); }
"printf"|"scanf"	{  insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
"main" 			{  insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
{alpha}({alpha}|{digit})*    		{
						insertToHash(yytext,"IDENTIFIER",yylineno);
						return IDENTIFIER; 
						
					}
[ \t\v\n\f]		{  }  // a ignorer
.			{  }
%%

struct cnode
{
	char num[50];
	//int lno;
	char type[20];
};
struct cnode ctable[100];
int ccount = 0;

void insertToConstTable(char *num, int l, char *type)
{
	strcpy(ctable[ccount].num, num);
	strcpy(ctable[ccount].type, type);
	//ctable[ccount].lno = l;
	ccount++;
}

void disp()
{
	int i;
	printf("\n\n------------------------------Table des Constantes------------------------------\n");
	printf("--------------------------------------------------------------------------\n");
	printf("Value \t\t|\tData Type\t\t\n");
	printf("--------------------------------------------------------------------------\n");
	for(i=0;i<ccount;i++)
	{
		printf("%s\t\t\t", ctable[i].num);
		printf("%s\t\t\t\n", ctable[i].type);
		//printf("\t%d\t\n", ctable[i].lno);
	}
	printf("\n\n");
}

struct node
{
	char token[100];
    	char attr[100];
    	//int line[100];
    	int line_count;
	struct node *next;
};

struct hash
{
	struct node *head;
	int hash_count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr, int l)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	//newnode->line[0] = l;
	newnode->line_count = 1; 
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr, int l)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr, l);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].hash_count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		//myNode->line[(myNode->line_count)++] = l;
            		if(strcmp(myNode->attr, attr)!=0)
            		{
            			strcpy(myNode->attr, attr);
            		}
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].hash_count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("\n-----------------------------------------Table de Symboles---------------------------------------------\n");
    	printf("--------------------------------------------------------------------------------------------------");
    	printf("\nToken \t\t|\tToken Type \t\t\t\t\t \n");
        printf("--------------------------------------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].hash_count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		//printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\t\t", myNode->attr);
            		/*for(j=0;j<(myNode->line_count);j++)
            			printf("%d  ",myNode->line[j]);*/
            		printf("\n");
            		myNode = myNode->next;
        	}
	}
	printf("--------------------------------------------------------------------------------------------------\n");
   	return;
}

yywrap()
{
	return(1);
}

multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}
