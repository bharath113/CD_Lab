%{
int comm=0;
#include<stdio.h>

%}

D [0-9]
L [a-zA-Z]
O [-+*/=<>|"=="]
WS [ \t\n]
E [Ee][-+]?{D}+
RM [,.;{}()]
Qu ["']
header "#include<"
close ".h>"
%%

"/*" if(comm=0){ comm=1; }
{header}{L}*{close} { ECHO; printf(" This is a header file tag");}
"auto"	{ECHO; printf(" Keyword\n");}
"break"	{ECHO; printf(" Keyword\n");}
"case"	{ECHO; printf(" Keyword\n");}
"char"	{ECHO; printf(" Keyword\n");}
"const"	{ECHO; printf(" Keyword\n");}
"continue" {ECHO; printf(" Keyword\n");}
"default" {ECHO; printf(" Keyword\n");}
"do" {ECHO; printf(" Keyword\n");}
"double" {ECHO; printf(" Keyword\n");}
"else"	{ECHO; printf(" Keyword\n");}
"enum"	{ECHO; printf(" Keyword\n");}
"extern" {ECHO; printf(" Keyword\n");}
"float"	{ECHO; printf(" Keyword\n");}
"for"	{ECHO; printf(" Keyword\n");}
"goto"	{ECHO; printf(" Keyword\n");}
"if"	{ECHO; printf(" Keyword\n");}
"int"	{ECHO; printf(" Keyword\n");}
"long"	{ECHO; printf(" Keyword\n");}
"register" {ECHO; printf(" Keyword\n");}
"return" {ECHO; printf(" Keyword\n");}
"short"	 {ECHO; printf(" Keyword\n");}
"signed" {ECHO; printf(" Keyword\n");}
"sizeof" {ECHO; printf(" Keyword\n");}
"static" {ECHO; printf(" Keyword\n");}
"struct" {ECHO; printf(" Keyword\n");}
"switch" {ECHO; printf(" Keyword\n");}
"typedef" {ECHO; printf(" Keyword\n");}
"union"	 {ECHO; printf(" Keyword\n");}
"unsigned" {ECHO; printf(" Keyword\n");}
"void"	{ECHO; printf(" Keyword\n");}
"volatile" {ECHO; printf(" Keyword\n");}
"while"	 {ECHO; printf(" Keyword\n");}
"printf" {ECHO; printf(" Function\n");}
"scanf" {ECHO; printf(" Function\n");}
{D}*+"."+{D}* {ECHO; printf(" Floating number\n");}
{D}* {ECHO; printf(" Integer\n");}
{Qu}+({L}|{D})*+{Qu} {ECHO; printf(" This is the string\n");} 
{L}({L}|{D})* {ECHO; printf(" Identifier\n");}
"--" {ECHO; printf(" operator\n");}
"++" {ECHO; printf(" operator\n");}
{RM} {}
{Qu} {}
{O} {ECHO; printf(" operator\n");}
{WS} {}
%%

int main()
{
yyin=fopen("abc.txt","r");
yylex();
}
int yywrap()
{
return(1);
}

