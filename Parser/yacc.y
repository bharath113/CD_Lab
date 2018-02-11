%{
#include<stdio.h>
%}

%token ID NUM TYPE MAIN HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK

%% 
S : M {printf("input accepted");exit(0);}
M: HEADER HEADER  ST;
HEADER : HEAD | ;

ST :   TYPE ID '(' ARG ')' '{' BODY '}' ST | ; 

ARG : DEC ',' ARG |DEC |   ;

RET :  RETURN K ;
K : ID|NUM ;
BODY : BODY BODY | R ';' | DEC ';'| WLOOP | FLOOP | IFEL | EXP | RET ';' | BREAK ';'  |  ;
SINGLE : R';'|DEC';'|WLOOP|FLOOP|IFEL|RET';'|COND';'|BREAK ';'|EXP ;

R : E '=' E | E ;
E : E '+' T | T ;
T : T '-' P | P ;
P : P '*' S | S ;
S : S '/' Q | Q ;
Q : Q UN | ID | NUM ;

DEC : TYPE VAR ;
VAR : TT ',' VAR | TT ;
TT : ID | ID '=' NUM ;


WLOOP : WHILE '(' COND ')' WDEF ;
WDEF : '{' BODY '}' | SINGLE ;
COND : EXP COP COND| EXP ;
EXP : ID | ID OP ID | ID OP NUM | NUM;

FLOOP : FOR '(' R ';' COND ';' R ')' FDEF ;
FDEF : '{' BODY '}' | SINGLE ;

IFEL : IF '(' COND ')' IDEF 
       | IF '(' COND ')' IDEF ELSE IDEF ;
IDEF : '{' BODY '}' | SINGLE ;

%%


extern int yylineno;
void yyerror()
 {
  printf("Invalid expression at %d",yylineno);
 }
 extern FILE *yyin;
int main()
 {
  yyin=fopen("input.txt","r");
  yyparse();
 }
