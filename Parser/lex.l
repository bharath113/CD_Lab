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
%}
datatype "int"|"float"|"char"
alpha [a-zA-Z]
digit [0-9]
header "#include<"
had  ".h>"
noperators ">="|"<="|"=="|">"|"<"|"!="|"-="|"+="|"*="|"/="
coperators "&&"|"||"
unary     "++"|"--"
dot [.]
decimal {digit}{digit}*{dot}{digit}{digit}*
sign [-]
negnum {sign}{digit}+
%%
[\t ]
[\n] {yylineno++;}
{noperators}      { insert(yytext,'O',yylineno,"NA"); return OP;}
{coperators}       { insert(yytext,'O',yylineno,"NA"); return COP;}
{unary}            { insert(yytext,'O',yylineno,"NA"); return UN;}
{header}(.)*{had} {  return HEAD;}
while             {  insert(yytext,'K',yylineno,"NA");return WHILE;}
for               {  insert(yytext,'K',yylineno,"NA");return FOR;} 
if		  {  insert(yytext,'K',yylineno,"NA");return IF;}
else              {  insert(yytext,'K',yylineno,"NA");return ELSE;} 
break             {  insert(yytext,'K',yylineno,"NA");return BREAK;} 
return           {  insert(yytext,'K',yylineno,"NA");return RETURN;}
{datatype}         { strcpy(data,yytext); insert(yytext,'D',yylineno,"NA");return TYPE;}
main        {  insert(yytext,'M',yylineno,"NA");return ID;}
";"         {  insert(yytext,'P',yylineno,"NA");return SEMI;}
","         {  insert(yytext,'P',yylineno,"NA");return COMMA;}
"("         {  insert(yytext,'P',yylineno,"NA");return BO;}
")"         {  insert(yytext,'P',yylineno,"NA");return BC;}
"{"         {  insert(yytext,'P',yylineno,"NA");return FO;}
"}"         {  insert(yytext,'P',yylineno,"NA");return FC;}
{digit}+   {insert(yytext,'N',yylineno,"Int");  return NUM;}
{decimal}   {insert(yytext,'N',yylineno,"Float");  return NUM;}
{negnum}    {insert(yytext,'N',yylineno,"Int");  return NUM;}
{alpha}({alpha}|{digit})* { insert(yytext,'V',yylineno,data); return ID;}
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
			 printf("%s \t %s \t %d \t %s\n",yytext,token,l,type);
        }
    
    
}


