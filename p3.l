%{
int comm=0;
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int var_cnt=0;
void insert(char *yytext,char t);
struct Storage
{
 char *name, token[20];
 int val;
 struct Storage *next;
}*st,*head;
int braces=0;
int opbrc=0; //open braces ( )
int quo=0; 
%}

D [0-9]
L [a-zA-Z]
O [-+*/=<>|"=="]
WS [ \t\n]
E [Ee][-+]?{D}+
PUN [,.;]
U [_]
Qu ["']
per [%&]
Keyword "break"|"case"|"continue"|"default"|"enum"|"register"|"return"|"sizeof"|"static"|"typedef"|"void"|"volatile"
Datatype "char"|"double"|"float"|"int"|"union"|"struct"
Loop "do"|"for"|"while"|"goto"
Condition "if"|"else"|"switch"

EDT "auto"|"short"|"long"|"const"|"extern"|"signed"|"unsigned"
FS "d"|"f"|"c"|"s"|"ld"|"lf"
SB "["|"]"


headerFunc "printf"|"scanf"
header "#include<"
close ".h>"
def "#define"|"# define"
String {Qu}+({L}|{D}|{per}|" ")*+{Qu}
IFR ({L}|{U})({L}|{D})*
array {IFR}{SB}{D}*{SB}
wl {D}({L}|{D})*
%%
"/*" { comm++; }
"*/" if(comm==1){ comm--; } else { comm--; printf("Error: Encountered a */ before /*\n"); }

{header}{L}*{close}                           { insert(yytext,'P');}
{def}                                         { insert(yytext,'P');}

{Keyword}                                     {if(comm==0) { insert(yytext,'k');}}
{Datatype}                                    {if(comm==0){ insert(yytext,'d');} }
{Loop}                                        {if(comm==0){ insert(yytext,'l');} }
{Condition}                                   {if(comm==0){  insert(yytext,'c');}}
{EDT}+" "+{EDT}*+" "+{Datatype}               {if(comm==0){ insert(yytext,'e');} } 

{headerFunc}                                  {if(comm==0){  insert(yytext,'h');}}

({D}+)+"."+{D}*                               {if(comm==0){ insert(yytext,'C');} }
{D}*                                          {if(comm==0){  insert(yytext,'C');}}
{String}                                      {if(comm==0){ insert(yytext,'s');} } 


{array}                                      {if(comm==0){ insert(yytext,'a'); }}
{Qu}+{IFR} { {printf(" %s Error Quotes not ended \n",yytext);}}
{IFR}+{Qu}+{IFR} { {printf(" %s Error Wrong usage of Quotes \n",yytext);}}
{IFR}+{Qu} { {printf(" %s Error Quotes not started \n",yytext);}}

{wl}  { {printf(" %s Wrong language used\n",yytext);} }
{IFR}                                          {if(comm==0&&quo==0){  insert(yytext,'v');}}

{IFR}+"."+{IFR}                                {if(comm==0){  insert(yytext,'v');} }
{PUN}                                          { if(comm==0)  insert(yytext,'p');}
"{"                                            {  braces++;  insert(yytext,'p');}
"}"                                            {  braces--;  insert(yytext,'p');}
"("                                            {  opbrc++;  insert(yytext,'p');}
")"                                            {  opbrc--; insert(yytext,'p');}
{Qu} {}

"--"                                           {if(comm==0){ insert(yytext,'o');} }
"++"                                           {if(comm==0){ insert(yytext,'o');} }

{per}                                          {if(comm==0){ insert(yytext,'o');}}
{O}                                            {if(comm==0){ insert(yytext,'o');}}

{WS} {}
{SB} {}
. { printf(" %s Errors\n",yytext);}
%%

int main()
{
yyin=fopen("test case 5.txt","r");
yyout=fopen("output 5.txt","w");
fprintf(yyout,"\n Symbol Table Format is:\n \tLexeme\t\t\t\tToken\t\t\tAttribute Value\n");
yylex();
if(comm>0) { printf("Comments does not end"); }
if(braces!=0)
 printf("ERROR!! No of braces does not match\n");
}
int yywrap()
{
return(1);
}

void insert(char *yytext,char t)
{
  int len1 = strlen(yytext);
  int i;
    char token[20];
	struct Storage *symbol,*temp,*nextptr;
	nextptr=head;
    switch(t)
    {
        case 'a':
             strcpy(token,"Array");
             break;
        case 'k':
        case 'd':
        case 'l':
        case 'e':
        case 'c':
            strcpy(token,"Keyword");
            break;

        case 'C':
            strcpy(token,"Constant");
            break;

        case 's':
            strcpy(token,"String");
            break;

        case 'v':
        case 'I':
            strcpy(token,"Identifier");
            break;

        case 'u':
            strcpy(token,"User defined function");
            break;

        case 'p':
            strcpy(token,"Punctuator");
            break;

        case 'o':
            strcpy(token,"Operator");
            break;

        case 'P':
            strcpy(token,"Pre processor");
            break;

        case 'h':
            strcpy(token,"Inbuilt Function");
            break;
    }
    
        for(i=0;i<var_cnt;i++,nextptr=nextptr->next)
		{
			symbol = nextptr;
            if(strcmp(symbol->name,yytext)==0)
                break;                                                                                                
		}
        if(i==var_cnt)
        {
			temp = (struct Storage*)malloc(sizeof(struct Storage));
            temp->name = (char*)malloc((len1+1)*sizeof(char));
			strcpy(temp->name,yytext);
            strcpy(temp->token,token);
			temp->val = i;
			temp->next = NULL;
			if(var_cnt==0)
				head = temp;
			else
				symbol->next = temp;
			var_cnt++;
        fprintf(yyout,"\n%20s%30.30s%20d",yytext,token,i);
        }
    
}

