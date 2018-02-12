%{
#include<stdio.h>
%}

%token ID NUM TYPE MAIN HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC

%% 
S : M {printf("input accepted");exit(0);}
M: HEADER ST;
HEADER : HEADER HEAD | ;

ST :   TYPE ID BO ARG BC FO BODY FC ST | ; 

ARG : DEC COMMA ARG |DEC |   ;

BODY : BODY BODY | R SEMI | DEC SEMI| WLOOP | FLOOP | IFEL | EXP SEMI | RET SEMI | BREAK SEMI  |  ;
SINGLE : R SEMI|DEC SEMI|WLOOP|FLOOP|RET SEMI|COND SEMI|BREAK SEMI|EXP SEMI| IFEL ;

RET :  RETURN K ;
K : ID|NUM ;

R : E '=' E | E ;
E : E '+' T | T ;
T : T '-' P | P ;
P : P '*' S | S ;
S : S '/' Q | Q ;
Q : Q UN | ID | NUM ;

DEC : TYPE VAR ;
VAR : TT COMMA VAR | TT ;
TT : ID | ID '=' NUM ;

WLOOP : WHILE BO COND BC WDEF ;
WDEF : FO BODY FC | SINGLE ;

COND : EXP COP COND| EXP ;
EXP : ID | ID OP ID | ID OP NUM | NUM;

FLOOP : FOR BO R SEMI COND SEMI R BC FDEF ;
FDEF : FO BODY FC | SINGLE ;

IFEL : IF BO COND BC IDEF 
       | IF BO COND BC IDEF ELSE IDEF ;

IDEF : FO BODY FC | SINGLE ;

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
