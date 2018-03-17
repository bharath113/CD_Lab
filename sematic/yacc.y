%{
#include<stdio.h>
#include<stdlib.h>
#include "symbol_table.h"
extern int column=0;
extern int line;
extern int cnt;
extern char *yytext,tempid[100];
extern int temp=3,err=0,err1=0,tchk=3;
int undec=0;


install()
{
	symrec *s;
	s = getsym (tempid);
	if (s == 0)
	s = putsym (tempid,temp);
	else
	{
		printf( "\nERROR: Semantic error at Pos : %d : %d : %s is already defined as %s\n",line,cnt,s->name,s->type );
		err1=1;
		
	}
}

int context_check()
{
	symrec *s;
	s = getsym(tempid);
	if (s == 0 )
	{
		printf( "\nERROR: Semantic error at Pos : %d : %d : %s is an undeclared identifier\n",line,cnt,tempid);//exit(0);
		err1=1;
		undec=1;		
	}
	else
	{
        if(strcmp(s->type,"void")==0)
            return(1);
        if(strcmp(s->type,"int")==0)
            return(3);
        if(strcmp(s->type,"float")==0)
            return(4);
        if(strcmp(s->type,"char")==0)
	        return(2);
	}
}

int type_err(int t1,int t2)
{
	if(t2 == 0)
		t2 = tchk;
	if(t1!=t2&&undec==0)
	{
		printf( "\nERROR: Semantic error : Type mismatch! at %d : %d\n\n",line,cnt);
		err1=1;
		return -1;
	}
	tchk=3;
        undec=0;
    return t1;
}

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

ARG : TYPE ID {install();}
    | TYPE ID COMMA ARG {install();}
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
    | RETURN BREAK
    | error ;

K : ID {$$=context_check();}
  |NUM {temp=3;};

R : CHE '=' A {$$=type_err($1,$3);}
  | A {$$=$1;}
  | error ;
A : A '+' B { $$=type_err($1,$3);}
  | A '-' B { $$=type_err($1,$3);}
  | B {$$=$1;};
B : B '*' C {$$=type_err($1,$3);}
  | B '/' C {$$=type_err($1,$3);}
  | C {$$=$1;};
C : ID UN {$$=context_check();}
  | ID {$$=context_check();}
  | NUM {$$=3;}
  | '(' A ')' {$$=$1;};
CHE : ID {$$=context_check();}
DEC : TYPE VAR 
VAR : TT COMMA VAR;
    | TT  
    | error;
TT : ID  {install();}
   | ID '=' ID {install();}
   | ID '=' NUM;

WLOOP : WHILE BO COND BC WDEF 
      | error;
WDEF : FO BODY FC 
     | single ;

COND : EXP COP COND {$$=type_err($1,$3);}
     | EXP {$$=$1;}
     | error;
EXP : CHE {$$=context_check();}
    | CHE OP CHE {$$=type_err($1,$3);}
    | CHE OP NUM {$$=type_err($1,$3);}
    |NUM {$$=3;}
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
extern void printa();
void yyerror()
 {
  printf("Invalid expression at %d \n",yylineno);
 }
 extern FILE *yyin;
 extern FILE *yyout;
int main()
 {
 
  yyin=fopen("file.txt","r");
  yyparse();
  print();
 }
