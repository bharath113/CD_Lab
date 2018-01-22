%{
int comm=0;
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int var_cnt=0;
void insert(char *yytext,char t,int l);
struct Storage
{
 char *name, token[20];
 int val;
 int li;
 struct Storage *next;
}*st,*head;
int braces=0;
int opbrc=0; //open braces ( )
int quo=0; 
int line=1;
%}

D [0-9]
L [a-zA-Z]
O [-+*/=<>|"=="]
WS [ \t\n|"\\"]
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
ws2 "\\"{Qu}

headerFunc "printf"|"scanf"
header "#include<"
close ".h>"
def "#define"|"# define"
String {Qu}({L}|{D}|{per}|{WS}|{O}|{ws2})*{Qu}
IFR ({L}|{U})({L}|{D})*
array {IFR}{SB}{D}*{SB}
wl {D}({L}|{D})*
%%
"\n" line++;
"/*" { if(comm==0) comm++; }
"*/" if(comm==1){ comm--; } else {  printf("Error: Encountered a */ before /*\n"); }

{header}{L}*{close}                           { insert(yytext,'P',line);}
{def}                                         { insert(yytext,'P',line);}

{Keyword}                                     {if(comm==0) { insert(yytext,'k',line);}}
{Datatype}                                    {if(comm==0){ insert(yytext,'d',line);} }
{Loop}                                        {if(comm==0){ insert(yytext,'l',line);} }
{Condition}                                   {if(comm==0){ insert(yytext,'c',line);} }
{EDT}+" "+{EDT}*+" "+{Datatype}               {if(comm==0){ insert(yytext,'e',line);} } 

{headerFunc}                                  {if(comm==0){  insert(yytext,'h',line);}}

({D}+)+"."+{D}*                               {if(comm==0){ insert(yytext,'C',line);} }
{D}*                                          {if(comm==0){  insert(yytext,'C',line);}}
{String}                                      {if(comm==0){ insert(yytext,'s',line);} } 


{Qu}+{IFR} { {printf(" %s Error Quotes not ended at line %d \n",yytext,line);}}
{IFR}+{Qu}+{IFR} { {printf(" %s Error Wrong usage of Quotes at line %d\n",yytext,line);}}
{IFR}+{Qu} { {printf(" %s Error Quotes not started at line %d\n",yytext,line);}}

{wl}  { {printf(" %s Wrong language used\n",yytext);} }
{IFR}                                          {if(comm==0&&quo==0){  insert(yytext,'v',line);}}

{IFR}+"."+{IFR}                                {if(comm==0){  insert(yytext,'v',line);} }
{PUN}                                          { if(comm==0)  insert(yytext,'p',line);}
"{"                                            {  braces++;  insert(yytext,'p',line);}
"}"                                            {  braces--;  insert(yytext,'p',line);}
"("                                            {  opbrc++;  insert(yytext,'p',line);}
")"                                            {  opbrc--; insert(yytext,'p',line);}
{Qu} {}

"--"                                           {if(comm==0){ insert(yytext,'o',line);} }
"++"                                           {if(comm==0){ insert(yytext,'o',line);} }

{per}                                          {if(comm==0){ insert(yytext,'o',line);}}
{O}                                            {if(comm==0){ insert(yytext,'o',line);}}

{WS} {}
{SB} {if(comm==0){ insert(yytext,'p',line);} }
. ;
%%

int main()
{
yyin=fopen("test case 5.txt","r");
yyout=fopen("output 5.txt","w");
fprintf(yyout,"\n Symbol Table Format is:\n \tLexeme\t\t\t\tToken\t\t\tLine No\t\t\tAttribute Value\n");
yylex();
if(comm>0) { printf("Comments does not end"); }
}
int yywrap()
{
return(1);
}

void insert(char *yytext,char t,int l)
{
  int len1 = strlen(yytext);
  int i;
    char token[20];
	struct Storage *symbol,*temp,*nextptr;
	nextptr=head;
    switch(t)
    {
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
        case 'a':
        case 'v':
        case 'I':
         case 'h':
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
			temp->li = l;
			temp->next = NULL;
			if(var_cnt==0)
				head = temp;
			else
				symbol->next = temp;
			var_cnt++;
       
        }
     fprintf(yyout,"\n%20s%30.30s%20d%20d",yytext,token,l,i);
}

