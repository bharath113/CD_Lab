%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "symbol_table.h"

extern int line;
extern int cnt;
extern char *yytext,tempid[100],temp_val[100], proName[20];
extern int temp=3,isArr=0;
extern char arrDim[10], list[10];
int templist[10];
extern int proDef=0;
extern int nestlvl;
int func_arg=0;
int func_no=0;
extern int scope_complete();
int paracnt=0,Oparacnt=0;
extern int funcCall=0;
int args_no=0;
int func_type=0;

int scope_complete()
{
 update(nestlvl);
}

int check_type_err(int t1, int t2)
{
if(t1!=t2) 
  printf("ERROR: Semantic error in line %d : The return type does not valid\n",line);
}

void install()
{
	symtbl *s;	
	s = getsym (tempid,nestlvl,func_no,funcCall);
	if (s == 0)
	{
	 if(proDef==1)
	   strcpy(proName,tempid);
	s = putsym(tempid,temp,arrDim,list,proDef,nestlvl,isArr,func_no,func_arg);}
	else
	{
	   int k = s->nestingLevel;
	   if(nestlvl == k)
	   {
		printf( "\nERROR: Semantic error in line %d : %s is already defined as %s\n",line,s->name,s->type );
                
		}
	   else
	   {
	    s = putsym (tempid,temp,arrDim,list,proDef,nestlvl,isArr,func_no,func_arg);
	   }
	}
	strcpy(temp_val,"");
	strcpy(arrDim,"0");
	isArr=0;
}



int context_check()
{
	symtbl *s;
	s = getsym(tempid,nestlvl,func_no,funcCall);          
	if (s != 0 && nestlvl >= s->nestingLevel)
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
	else
	{
	    
	       	printf( "\nERROR: Semantic error in line %d : %s is an undeclared identifier in this level\n",line,tempid);
	       	//exit(0);
		return 0;
	   
	}
}

int type_err(int t1,int t2)
{
	if(t2 == 0)
		t2 = temp;
    if(t1==4&&t2==3)
        return t1;
    else if(t1==3&&t2==4)
        return t1;
    
   
	if(t1!=t2  && t1!=0) 
	{
		printf( "\nERROR: Semantic error : Type mismatch! at %d : %d\n",line,cnt);
		return 0;
	}
	
    if(t1==t2)
      return t1;
    else
    {
      return 0;
    }
}

int update_cnt()
{
 updatecnt(proName,func_no,Oparacnt,templist);   
 Oparacnt=0;      
}

int check_bound()
{
  symtbl *s;
  int val;
	s = getsym(tempid,nestlvl,func_no,funcCall);
    val=strcmp(temp_val,s->arrDim);
    if(val==0)
      return 1;
    else 
      return 0;
}

int check_paracnt()
{
 int s;
 s = isCntValid(proName,paracnt,templist);
 if(s==0)
  {
   printf( "\nERROR: Semantic error : Two few arguments %d \n",line,cnt);
  }
  else if(s==-1)
   {
    printf("\nERROR: Semantic error : Two many arguments %d : %d\n",line,cnt);
   }
  else if(s==-2)
  {
   printf("\nERROR: Semantic error :Type mismatch in arguments %d : %d\n",line,cnt);
  }
}

%}

%token ID FNUM NUM HEAD WHILE OP COP FOR UN IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC INT CHAR FLOAT VOID STRING CHARVAL NEGNUM MINUS MAIN

%% 
S : Header Start {printf("\nParsing Completed\n");
                  printf("Lexeme\tType\tArrayDim  Procedure Definition  nesting level  Belongs to Func  Parameters list \n");
                  printf("----------------------------------------------------------------------------------\n");
		  print();
		  
printf("\nNOTE: in Procedure definition \n0: It is not a procedure call\n1: It is a procedure call\nIf array Dimention is 0 then it is not an array\n");
		  exit(0);
		 }
Header : HEAD Header 
       | 
       ;


Start : Start Type Name BO ARGs BC FO BODY FC Start {func_no--;}
      |   {func_no++;} 
      ; 
Name: ID {func_type=temp; proDef=1; install(); proDef=0;Oparacnt=0; }

ARGs: ARG {  update_cnt();func_arg=0;};
    |  ;
ARG: ARG COMMA ARG { func_arg=1;}
   | Type ID {Oparacnt++; templist[Oparacnt-1]=temp; install(); func_arg=1;};
   
Type  : INT {temp = 3;}
      | FLOAT {temp = 4;}
      | CHAR {temp = 2;} 
      | VOID {temp =1; } ;
   

BODY : Bb BODY 
     |
     |error
     ;

Bb : R SEMI 
   | DEC SEMI
   | WLOOP 
   | FLOOP 
   | IFEL 
   | EXP SEMI 
   | RET SEMI 
   | BREAK SEMI
   | SEMI
   | COND SEMI
   | pcall SEMI  ;

pcall : P BO v BC { if($$!=0)check_paracnt(); paracnt=0; $$=$1;};
P: ID {strcpy(proName,tempid); funcCall=1; $$ = context_check(); funcCall=0;}
v : vari | ;
vari  : vari COMMA vari 
      | K {paracnt++; templist[paracnt-1]=$1;};
      

DEC : Type VAR
 
VAR : TT COMMA VAR;
    | TT  
    | error;
    
TT : ID {install();}
   | ID '=' K {if(type_err(temp,$3)!=0) install();}
   | ID '=' NEGNUM {if(type_err(temp,3)!=0) install();}
   | ID '[' L ']' { isArr=1;  install();}
   | ID '[' L ']' '=' K  {isArr=1;  if(type_err(temp,$6)&&$6!=3&&$6!=4) install(); if($6==3 || $6==4) printf("\nERROR: Semantic error : Wrong declaration at %d : %d\n",line,cnt);}
   | ID '[' L ']' '=' assin  {isArr=1; 
   							  int i=atoi(arrDim);
   							  args_no=0;
   							  if(temp==2&&$6==2&&args_no>1){ printf( "\nERROR: Semantic error : Type mismatch! at %d : %d\n",line,cnt); } if(type_err(temp,$6)) install(); };
L: NUM {strcpy(arrDim,temp_val);}

assin : FO val FC {$$=$2;};
val : val COMMA val { $$=type_err($1,$3); }
   | typ { $$=type_err(temp,$1); args_no++; }
   | ;
typ : NUM {$$=3;}
    | NEGNUM {$$=3;}
    | FNUM {$$=4;} 
    | CHARVAL {$$=2;}
    | STRING {$$=2;} ;


CHE : ID {$$=context_check();}
    | ID '[' NUM ']' { $$=context_check();
                        /*if(check_bound()==0&&$$!=0) 
                       printf("the index is out of range at %d : %d\n",line,cnt);*/
                     }
    | ID '[' CHE ']' {if(type_err(3,$3)) $$=context_check();} ;
    
    
RET :  RETURN K {check_type_err(func_type,$2);}
    |  RETURN R {check_type_err(func_type,$2);}
    | error ;

COND : EXP COP COND 
     | EXP 
     | error;
EXP : CHE OP K {$$=type_err($1,$3);}
    | K 
    | error;

K : CHE {$$=$1;} 
  | NUM {$$=3;}
  | FNUM {$$=4;};
  | CHARVAL {$$=2;}
  | STRING {$$=2;}
  | NEGNUM {$$=2;}

R : CHE '=' A {$$=type_err($1,$3); }
  | CHE '=' pcall {$$=type_err($1,$3);}
  | A {$$=$1;}
  | error ;
A : A '+' B { $$=type_err($1,$3);}
  | A '-' B { $$=type_err($1,$3);}
  | B {$$=$1;};
B : B '*' C {$$=type_err($1,$3);}
  | B '/' C {$$=type_err($1,$3);}
  | C {$$=$1;};
C : CHE UN { type_err($1,3);}
  | K {$$=$1;};
  | '(' NEGNUM ')' {$$=3;}
  | '(' A ')' {$$=$2;};
  
  

    
WLOOP : WHILE BO COND BC WDEF 
      | error;
WDEF : FO BODY FC 
     | Bb ;


FLOOP : FOR BO argu SEMI con SEMI inc BC FDEF;
argu : DEC 
     | ;
con  : con COMMA COND
     | COND 
     | ;
inc  : inc COMMA R
     | R
     | ;
     
FDEF : FO BODY FC 
     | Bb ;

IFEL : IF BO COND BC IDEF 
     | IF BO COND BC IDEF ELSE IDEF ;
     
IDEF : FO BODY FC 
     | Bb ;

%%

extern int yylineno;
extern void printa();
void yyerror()
 {
  printf("Invalid expression at %d : %d\n",line,cnt);
 }
 extern FILE *yyin;
 extern FILE *yyout;
int main()
 {
  yyin=fopen("file.txt","r");
  yyparse();
  print();
 }
