%{
#include<stdio.h>
#include<stdlib.h>

%}

%token ID NUM TYPE MAIN HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC

%% 
S : M {printf("\nParsing Completed\n");exit(0);}
M: HEADER ST;
HEADER : HEAD HEADER | ;

ST :   TYPE ID BO ARG BC FO BODY FC ST | ; 


ARG : TYPE ID| TYPE ID COMMA ARG| ;

BODY : Bb BODY| ;
Bb :  R SEMI | DEC SEMI| WLOOP | FLOOP | IFEL |EXP SEMI | RET SEMI | BREAK SEMI| SEMI ;
SINGLE : R SEMI|DEC SEMI|WLOOP|FLOOP|RET SEMI|BREAK SEMI|EXP SEMI|COND SEMI| IFEL ;

RET :  RETURN K | error ;
K : ID|NUM ;

R : ID '=' A | A | error ;
A : A '+' B | A '-' B | B;
B : B '*' C | B '/' C | C ;
C : C UN | ID | NUM | '('A')' ;

DEC : TYPE VAR;
VAR : TT COMMA VAR | TT  | error;
TT : ID | ID '=' ID| ID '=' NUM;

WLOOP : WHILE BO COND BC WDEF | error;
WDEF : FO BODY FC | SINGLE ;

COND : EXP COP COND| EXP | error;
EXP :  ID | ID OP ID | ID OP NUM |NUM| error;

FLOOP : FOR BO Aa SEMI Bb SEMI Cc BC FDEF  ;
Aa : TYPE R | R | ;
Bb : COND | ;
Cc : R| ;
FDEF : FO BODY FC | SINGLE ;

IFEL : IF BO COND BC IDEF 
       | IF BO COND BC IDEF ELSE IDEF ;

IDEF : FO BODY FC | SINGLE ;

%%

extern int yylineno;
void yyerror()
 {
  printf("Invalid expression at %d\n",yylineno);
 }
 extern FILE *yyin;
 extern FILE *yyout;
int main()
 {
  printf("Lexeme\tDescription\tLine no\tType\n");
  printf("------------------------------------------------------------\n");
  yyin=fopen("input.txt","r");
  yyout=fopen("output.txt","w");
  yyparse();
 }
