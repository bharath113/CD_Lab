%option noyywrap
%{
 #include "y.tab.h"
 
char temp_val[100],proName[20]; //1st stores the constants and 2nd var stores the procedure name
int funcCall; // to check whether the id is the func call or not
int cnt=1; // it is the number on the line
int line=1;// this is the line number
char tempid[100]; // stores the name of id
char arrDim[10]="0";//
int nestlvl=0;//  
int proDef; 
char list[10]="NA"; //
%}
A [a-zA-Z]
digit [0-9]
header "#include<"
had  ".h>"
ope "-="|">="|"<="|"=="|">"|"<"|"!="|"+="|"*="|"/="
conope "&&"|"||"
unary     "++"|"--"
dot [.]
decimal {digit}{digit}*{dot}{digit}{digit}*
sign [-]
negnum {sign}{digit}+
%%
[\t] 								{cnt+=4; }
[ ] 								{cnt++;}
[\n] 							    {line++; cnt=1; }
{ope}      						    { cnt+=yyleng; return OP;}
{conope}       						{ cnt+=yyleng; return COP;}
{unary}           					{ cnt+=yyleng; return UN;}
{header}(.)*{had} 					{ return HEAD;}
while             					{ cnt+=yyleng; return WHILE;}
for              					{ cnt+=yyleng;return FOR;} 
if		  							{  cnt+=yyleng;return IF;}
else             					{  cnt+=yyleng;return ELSE;} 
break             					{  cnt+=yyleng;return BREAK;} 
return           					{ cnt+=yyleng; return RETURN;}
int         						{  cnt+=yyleng; return INT;}
float       						{  cnt+=yyleng; return FLOAT;}
char        						{  cnt+=yyleng; return CHAR;}
void        						{  cnt+=yyleng;  return VOID;}
main        						{strcpy(tempid,yytext); cnt+=yyleng;  return ID;}
";"         						{ cnt+=yyleng; return SEMI;}
","         { cnt+=yyleng;  return COMMA;}
"("         { nestlvl++; cnt+=yyleng; return BO;}
")"         { nestlvl--; cnt+=yyleng; return BC;}
"{"         { nestlvl++; if(nestlvl==1)proDef=0; cnt+=yyleng; return FO;}
"}"         { scope_complete(); nestlvl--; if(nestlvl==0) proDef=1; cnt+=yyleng;return FC;}
(\"|\')({A}|{digit})(\"|\')     { cnt+=yyleng; strcpy(temp_val,yytext); return CHARVAL;}
{digit}+    					{strcpy(temp_val,yytext); cnt+=yyleng;  return NUM;}
{decimal}  						 {strcpy(temp_val,yytext); cnt+=yyleng; return FNUM;}
{A}({A}|{digit})* 				{ cnt+=yyleng; strcpy(tempid,yytext); if(proDef==1) strcpy(proName,yytext); return ID;}  
"-"{digit}+    				{strcpy(temp_val,yytext); cnt+=yyleng;return NEGNUM;}
A?\"(\\.|[^\\"])*\"			{ cnt+=yyleng; return STRING; }
\/\/.*			; 
\/\*(.\n)*\*\/	;
.                return yytext[0];
%%


