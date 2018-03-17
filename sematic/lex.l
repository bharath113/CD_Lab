%option noyywrap
%{
 #include "y.tab.h"
 void insert(char *yytext,char t,int l,char *type);
 struct Storage
{
 char *name, token[20], Data[10];
 int val;
 int li;
 struct Storage *next;
}*st,*head;
int var_cnt=0;
char data[10];
//int yylineno=1;
void printa();

int cnt=1;
int line=1;
char tempid[100];

%}
datatype "int"|"float"|"char"
A [a-zA-Z]
digit [0-9]
header "#include<"
had  ".h>"
ope ">="|"<="|"=="|">"|"<"|"!="|"-="|"+="|"*="|"/="
conope "&&"|"||"
unary     "++"|"--"
dot [.]
decimal {digit}{digit}*{dot}{digit}{digit}*
sign [-]
negnum {sign}{digit}+
%%
[\t ] {cnt+=yyleng;}
[\n] {line++; cnt=1; yylineno++;}
{ope}      { cnt+=yyleng;insert(yytext,'O',yylineno,"NA"); return OP;}
{conope}       { cnt+=yyleng;insert(yytext,'O',yylineno,"NA"); return COP;}
{unary}            { cnt+=yyleng;insert(yytext,'O',yylineno,"NA"); return UN;}
{header}(.)*{had} {  return HEAD;}
while             { cnt+=yyleng; insert(yytext,'K',yylineno,"NA");return WHILE;}
for               { cnt+=yyleng; insert(yytext,'K',yylineno,"NA");return FOR;} 
if		  {  cnt+=yyleng;insert(yytext,'K',yylineno,"NA");return IF;}
else              {  cnt+=yyleng;insert(yytext,'K',yylineno,"NA");return ELSE;} 
break             {  cnt+=yyleng;insert(yytext,'K',yylineno,"NA");return BREAK;} 
return           { cnt+=yyleng; insert(yytext,'K',yylineno,"NA");return RETURN;}
{datatype}         { cnt+=yyleng;strcpy(data,yytext); insert(yytext,'D',yylineno,"NA");return TYPE;}
main        { cnt+=yyleng; insert(yytext,'M',yylineno,"NA");return ID;}
";"         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return SEMI;}
","         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return COMMA;}
"("         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return BO;}
")"         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return BC;}
"{"         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return FO;}
"}"         { cnt+=yyleng; insert(yytext,'P',yylineno,"NA");return FC;}
{digit}+   {cnt+=yyleng;insert(yytext,'N',yylineno,"Int");  return NUM;}
{decimal}   {cnt+=yyleng;insert(yytext,'N',yylineno,"Float");  return NUM;}
{negnum}    {cnt+=yyleng;insert(yytext,'N',yylineno,"Int");  return NUM;}
{A}({A}|{digit})* { cnt+=yyleng; strcpy(tempid,yytext); insert(yytext,'V',yylineno,data); return ID;}
\/\/.*			; 
\/\*(.\n)*\*\/	;
.                return yytext[0];
%%


void insert(char *yytext,char t,int l, char *type)
{
  int len1 = strlen(yytext);
  int i;
    char token[20];
	struct Storage *symbol,*temp,*nextptr;
	nextptr=head;
    switch(t)
    {
        case 'V':
            strcpy(token,"Identifier");
            break;
        case 'N':
              strcpy(token,"Constants");
              break;
        case 'M':
              strcpy(token,"Function");
              break;
        case 'O':
              strcpy(token,"Operator");
              break;
        case 'K':
              strcpy(token,"Keyword");
              break;
        case 'P':
              strcpy(token,"Puntuators");
              break;
        case 'D':
              strcpy(token,"Datatype");
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
			strcpy(temp->Data,type);
			if(var_cnt==0)
				head = temp;
			else
				symbol->next = temp;
			var_cnt++;

        }
    
    
}
 void printa()
 {
  struct Storage *nextp=head;
  for(;nextp!=NULL;nextp=nextp->next)\
      if(strcmp(nextp->token,"Identifier")==0 || strcmp(nextp->token,"Constants")==0)
			 printf("%s \t %s \t %d \t %s\n",nextp->name,nextp->token,nextp->li,nextp->Data);
 }

