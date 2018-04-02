%option noyywrap
%{
 #include "y.tab.h"
 
int nestlvl=0; 
int proDef; 
char list[10]="-";
char temp_val[100],proName[20]; 
int funcCall; 
int cnt=1;
int line=1;
extern int only_if;
char tempid[100];
char tempnum[100];
char tempopi[10];
char arrDim[10]="0";
char ope[10];
%}
A [a-zA-Z]
digit [0-9]
header "#include<"
had  ".h>"
ope "-="|">="|"<="|"=="|"!="|"+="|"*="|"/="
conope "&&"|"||"
dot [.]
decimal {digit}{digit}*{dot}{digit}{digit}*
sign [-]
negnum {sign}{digit}+
%%
[\t] 								{cnt+=4; }
[ ] 								{cnt++;}
[\n] 							    {line++; cnt=1; }
{ope}      						    {strcpy(ope,yytext); cnt+=yyleng;strcpy(tempopi,yytext); return OP;}
{conope}       						{ cnt+=yyleng; return COP;}
{header}(.)*{had} 					{ return HEAD;}
while             					{ cnt+=yyleng; return WHILE;}
for              					{ cnt+=yyleng;return FOR;} 
if		  					{  cnt+=yyleng;only_if=1;return IF;}
else             					{  cnt+=yyleng;only_if=0;return ELSE;} 
break             					{  cnt+=yyleng;return BREAK;} 
return           					{ cnt+=yyleng; return RETURN;}
int         						{  cnt+=yyleng; return INT;}
float       						{  cnt+=yyleng; return FLOAT;}
char        						{  cnt+=yyleng; return CHAR;}
void        						{  cnt+=yyleng;  return VOID;}
main        						{strcpy(tempid,yytext); cnt+=yyleng;  return ID;}
"++"							{return plpl;}
"--"							{return pipi;}
";"         						{ cnt+=yyleng; return SEMI;}
","         { cnt+=yyleng;  return COMMA;}
"("         { nestlvl++; cnt+=yyleng; return BO;}
")"         { nestlvl--; cnt+=yyleng; return BC;}
"{"         { nestlvl++; if(nestlvl==1)proDef=0; cnt+=yyleng; return FO;}
"}"         { scope_check(); nestlvl--; if(nestlvl==0) proDef=1; cnt+=yyleng;return FC;}
(\"|\')({A}|{digit})(\"|\')     { cnt+=yyleng; strcpy(temp_val,yytext); return CHARVAL;}
{digit}+    					{strcpy(tempnum,yytext);strcpy(temp_val,yytext);cnt+=yyleng;  return NUM;}
{decimal}  						 {strcpy(temp_val,yytext); cnt+=yyleng; return FNUM;}
{A}({A}|{digit})* 				{ cnt+=yyleng; strcpy(tempid,yytext); if(proDef==1) strcpy(proName,yytext); return ID;}  
"-"{digit}+    				{strcpy(temp_val,yytext); cnt+=yyleng;return NEGNUM;}
A?\"(\\.|[^\\"])*\"			{ cnt+=yyleng; return STRING; }
\/\/.*			; 
\/\*(.\n)*\*\/	;
.                return yytext[0];
%%


