%{
#include<stdio.h>
%}

%token ID NUM TYPE MAIN HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC

%% 
S : M {printf("\nParsing Completed");exit(0);}
M: HEADER ST;
HEADER : HEADER HEAD | ;

ST :   TYPE ID BO ARG BC FO BODY FC ST | ; 

ARG : SDEC| |error;
SDEC : TYPE ID| TYPE ID COMMA SDEC | error;

BODY : BODY BODY | R SEMI | DEC SEMI| WLOOP | FLOOP | IFEL |EXP SEMI | RET SEMI | BREAK SEMI |SEMI |  ;
SINGLE : R SEMI|DEC SEMI|WLOOP|FLOOP|RET SEMI|BREAK SEMI|EXP SEMI|COND SEMI| IFEL ;

RET :  RETURN K | error ;
K : ID|NUM | error;

R : ID '=' E | E | error ;
E : E '+' P | P |E '-' P | error ;
P : P '*' SS | SS | error ;
SS : SS '/' Q | Q  | error ;
Q :  Q UN | ID | NUM | '('E')' | error ;

DEC : TYPE VAR | error;
VAR : TT COMMA VAR | TT | error;
TT : ID | ID '=' K| error;
K: ID | NUM |error;

WLOOP : WHILE BO COND BC WDEF | error;
WDEF : FO BODY FC | SINGLE | error;

COND : EXP COP COND| EXP | error;
EXP :  ID | ID OP ID | ID OP NUM |NUM| error;

FLOOP : FOR BO A SEMI COND SEMI R BC FDEF | error;
A : TYPE R | R |error;
FDEF : FO BODY FC | SINGLE | error;

IFEL : IF BO COND BC IDEF | error
       | IF BO COND BC IDEF ELSE IDEF | error;

IDEF : FO BODY FC | SINGLE | error;

%%


extern int yylineno;
void yyerror()
 {
  printf("Invalid expression at %d\n",yylineno);
 }
 extern FILE *yyin;
int main()
 {
  yyin=fopen("6.c","r");
  yyparse();
 }
