%{
#include<stdio.h>
#include<stdlib.h>

%}

%token ID NUM TYPE HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC

%% 
S : Header Start {printf("\nParsing Completed\n");
                  printf("Lexeme\tDescription\tLine no\tType\n");
                  printf("------------------------------------------------------------\n");
		  print();
		  exit(0);
		 }
Header : HEAD Header 
       | 
       ;

Start : TYPE ID BO ARG BC FO BODY FC Start 
      | 
      ; 

ARG : TYPE ID
    | TYPE ID COMMA ARG
    | 
    ;

BODY : Bb BODY
     |
     |error
     ;

Bb :  R SEMI 
   | DEC SEMI
   | WLOOP 
   | FLOOP 
   | IFEL 
   | EXP SEMI 
   | RET SEMI 
   | BREAK SEMI
   | SEMI ;

single : R SEMI
       |DEC SEMI
       |WLOOP
       |FLOOP
       |RET SEMI
       |BREAK SEMI
       |EXP SEMI
       |COND SEMI
       | IFEL 
       | SEMI ;

RET :  RETURN K 
    | error ;
K : ID
  |NUM ;

R : ID '=' A 
  | A 
  | error ;
A : A '+' B 
  | A '-' B 
  | B;
B : B '*' C 
  | B '/' C 
  | C ;
C : ID UN 
  | ID 
  | NUM 
  | '(' A ')' ;

DEC : TYPE VAR;
VAR : TT COMMA VAR 
    | TT  
    | error;
TT : ID 
   | ID '=' ID
   | ID '=' NUM;

WLOOP : WHILE BO COND BC WDEF 
      | error;
WDEF : FO BODY FC 
     | single ;

COND : EXP COP COND
     | EXP 
     | error;
EXP :  ID 
    | ID OP ID 
    | ID OP NUM 
    |NUM
    | error;

FLOOP : FOR BO Aa SEMI Bb SEMI Cc BC FDEF ;
Aa : TYPE R
   | R
   |
   ;
Bb : COND 
   |
   ;
Cc : R
   | 
   ;
FDEF : FO BODY FC 
     | single ;

IFEL : IF BO COND BC IDEF 
     | IF BO COND BC IDEF ELSE IDEF ;

IDEF : FO BODY FC 
     | single ;

%%

extern int yylineno;
extern int yytext;
extern void print();
void yyerror()
 {
  printf("Invalid expression at %d \n",yylineno);
 }
 extern FILE *yyin;
 extern FILE *yyout;
int main()
 {
 
  yyin=fopen("input.txt","r");
  yyparse();
  
 }
