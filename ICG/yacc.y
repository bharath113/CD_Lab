%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "symbol_tabel.c"
#include "codegen.c"

void yyerror(char *s);
extern int line;
extern int cnt;
int templist[10];
extern int proDef=0;
char tempop;
int whilecame,ifcame,only_if,forfor;
extern int nestlvl;
int func_arg=0;
int func_no=0;
extern int scope_check();
int parameters_count=0,Oparameters_count=0;
extern int funcCall=0;
extern char *yytext,tempid[100],temp_val[100], proName[20],tempnum[100],tempopi[10];
extern int temp=3,is_array=0;
extern char ope[10];
extern char arrDim[10], list[10];
int scope_check()
{
 update_scope(nestlvl);
}

void insert()
{
	symbol_table *s;	
	s = get_symbol(tempid,nestlvl,func_no,funcCall);
	if (s == 0)
	{
	 if(proDef==1)
	   strcpy(proName,tempid);
	s = insert_symbol(tempid,temp,arrDim,list,proDef,nestlvl,is_array,func_no,func_arg);}
	else
	{
	   int k = s->nestingLevel;
	   if(nestlvl == k)
	   {
		printf( "\nERROR: %s is already defined as %s at line no %d\n",s->name,s->type,line );

		}
	   else
	   {
	    s = insert_symbol (tempid,temp,arrDim,list,proDef,nestlvl,is_array,func_no,func_arg);
	   }
	}
	strcpy(temp_val,"");
	strcpy(arrDim,"0");
	is_array=0;
}



int context_check()
{
	symbol_table *s;
	s = get_symbol(tempid,nestlvl,func_no,funcCall);          
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
	    
	       	printf( "\nERROR: %s is an undeclared identifier at line no %d \n",tempid,line);
	       	//exit(0);

		//undec=1;	

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
		printf( "\nERROR:Type does not match at line no %d\n",line);
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
 update_parameters(proName,func_no,Oparameters_count,templist);   
 Oparameters_count=0;      
}

int check_bound()
{
  symbol_table *s;
  int val;
	s = get_symbol(tempid,nestlvl,func_no,funcCall);
    val=strcmp(temp_val,s->arrDim);
    if(val==0)
      return 1;
    else 
      return 0;
}

int check_parameters_count()
{
 int s;
 s = argscnt(proName,parameters_count,templist);
 if(s==0)
  {
   printf( "\nERROR: less arguments at line no %d \n",line);
  }
  else if(s==-1)
   {
    printf("\nERROR: more arguments at line no %d\n",line);
   }
  else if(s==-2)
  {
   printf("\nERROR: Type does not match in arguments at line no %d\n",line);
  }
}
%}

%token PP MM ID FNUM NUM HEAD WHILE OP COP FOR IF ELSE RETURN ASSIGNMENT BREAK SEMI COMMA BO BC FO FC INT CHAR FLOAT VOID STRING CHARVAL NEGNUM MINUS MAIN

%% 
S : Header Start {printf("\nParsing Completed\n");
printf("\n-------------------------------------------------------------------------------------------------------------------\n");
		printf("\nSYMBOL TABLE\n");
		printf("\n-------------------------------------------------------------------------------------------------------------------\n");
               printf("Lexeme\tType\tArrayDim  Procedure Definition  nesting level  Belongs to Func  Parameters list \n");
    
                  printf("----------------------------------------------------------------------------------\n");
		  print_symbol_table();
		  printf("\nNOTE: in Procedure definition \n0: It is not a procedure call\n1: It is a procedure call\nIf array Dimention is 0 then it is not an array\n");
		exit(0);
		 }
Header : HEAD Header 
       | 
       ;


Start : Start Type Name {printf("%s\n",tempid);}BO ARGs BC FO BODY FC {printf("EXIT\n");}Start {func_no--;}
      |   {func_no++;} 
      ; 
Name: ID {proDef=1; insert(); proDef=0;Oparameters_count=0; };

ARGs: ARG {  update_cnt();func_arg=0;};
    |  ;
ARG: ARG COMMA ARG { func_arg=1;}
   | Type ID {Oparameters_count++; templist[Oparameters_count-1]=temp; insert(); func_arg=1;};
   
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
   | {whilecame=0;ifcame=1;only_if=0;forfor=0;} IFEL 
   | EXP SEMI 
   | RET SEMI 
   | BREAK SEMI
   | SEMI
   | COND SEMI
   | pcall SEMI  ;

pcall : P BO v BC {check_parameters_count(); parameters_count=0; $$=$1;};
P: ID {createfun(tempid);strcpy(proName,tempid); funcCall=1; $$ = context_check();funcCall=0;}
v : vari | ;
vari  : vari COMMA vari 
      | K {parameters_count++; templist[parameters_count-1]=$1;};
      

DEC : Type VAR 
 
VAR : TT COMMA VAR;
    | TT  
    | error;
    
TT : ID {insert();}
   | ID '=' NUM {putin(tempid);putin(tempnum);create_tree(0);if(type_err(temp,$3)!=0) insert();}
   | ID '=' NEGNUM {if(type_err(temp,3)!=0) insert();}
   | ID '[' L ']' { is_array=1;  insert();}
   | ID '[' L ']' '=' K {is_array=1;  if(type_err(temp,$6)) insert(); }
   | ID '[' L ']' '=' NEGNUM  {is_array=1;  if(type_err(temp,3)) insert(); }
   | ID '[' L ']' '=' assin  {is_array=1; if(temp==2)if($6==2){ printf( "\nERROR: Semantic error : Type does not match at line no %d\n",line); } if(type_err(temp,$6)) insert(); };
L: NUM {strcpy(arrDim,temp_val);}

assin : FO val FC {$$=$2;};
val : typ COMMA val { $$=type_err(temp,$1); }
   | typ { $$=type_err(temp,$1); }
   | ;
typ : NUM {$$=3;}
    | NEGNUM {$$=3;}
    | FNUM {$$=4;} 
    | CHARVAL {$$=2;}
    | STRING {$$=2;} ;


CHE : ID {putin(tempid);$$=context_check();}
    | ID '[' NUM ']' { $$=context_check();
                        /*if(check_bound()==0&&$$!=0) 
                       printf("the index is out of range at %d : %d\n",line,cnt);*/
                     }
    | ID '[' CHE ']' {if(type_err(3,$3)) $$=context_check();} ;
    
    
RET :  RETURN K
    |  RETURN R
    | RETURN BREAK
    | error ;

COND : EXP COP COND 
     | EXP 
     | error;
EXP : CHE OP K {
                 if(!strcmp(ope,"<="))create_tree(7);
                 else if(!strcmp(ope,">="))create_tree(8);
                 else if(!strcmp(ope,"=="))create_tree(9);
                 else if(!strcmp(ope,"!="))create_tree(10);
                 $$=type_err($1,$3);
               }
    |  CHE '<' K {create_tree(5);$$=type_err($1,$3);}
    |  CHE '>' K {create_tree(6);$$=type_err($1,$3);}
    | K 
    | error;

K : CHE {$$=$1;} 
  | NUM {putin(tempnum);$$=3;}
  | FNUM {$$=4;}
  | CHARVAL {$$=2;}
  | STRING {$$=2;};

R : CHE '=' A {create_tree(0);$$=type_err($1,$3); }
  | CHE '=' pcall {$$=type_err($1,$3);}
  | A {$$=$1;}
  | error ;
A : A '+' B {create_tree(1);$$=type_err($1,$3);}
  | A '-' B {create_tree(2);$$=type_err($1,$3);}
  | B {$$=$1;};
B : B '*' C {create_tree(3);$$=type_err($1,$3);}
  | B '/' C {create_tree(4);$$=type_err($1,$3);}
  | C {$$=$1;};
C : K {$$=$1;};
  | '(' NEGNUM ')' {$$=3;}
  | '(' A ')' {$$=$2;}
  | CHE PP {putin(tempid);putin("1");create_tree(1);create_tree(0);type_err($1,3);}
  | CHE MM { putin(tempid);putin("1");create_tree(2);create_tree(0);type_err($1,3);};
  
  

    
WLOOP :  {labelforwhile();whilecame=1;ifcame=0;forfor=0;} WHILE BO COND BC WDEF {creategoto();}
      | error;
WDEF : FO BODY FC 
     | Bb ;


FLOOP : FOR BO argu SEMI {only_if=0;whilecame=0;ifcame=0;forfor=1;} con SEMI inc {gotoforstart();} BC FDEF {gotoforincre();};
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

IFEL : IF BO COND BC IDEF {afteronlyif();}
     | IF BO COND BC IDEF ELSE {labelforifafter();creategotoif();} IDEF {afterif();};

IDEF : FO BODY FC 
     | Bb ;

%%

extern int yylineno;
void yyerror(char *s)
 {
  printf("Invalid expression at line no %d\n",line);
 }
 extern FILE *yyin;
 extern FILE *yyout;
 
int main()
 {
 
  yyin=fopen("abc.txt","r");
  printf("\n-------------------------------------------------------------------------------------------------------------------\n");
  printf("\nTHREE ADDRESS CODE\n");
  printf("\n-------------------------------------------------------------------------------------------------------------------\n");
  yyparse();
  print_symbol_table();
 }
