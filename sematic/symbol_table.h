#define t_void	1
#define t_char	2
#define t_int	3
#define t_float	4

struct symtbl
{
	char *name; //name 
	char type[10];// stores type
	char arrDim[10]; 
	char list[200]; // stores the list of parameters
	int proDef; //bool
	int nestingLevel; //the nesting level
	int isArr; 
	int func_no; //this is to keep track of the functions ans also used for checking scope
	//int func_arg; //the number of arguments
	int scope_complete; //to check the scope of the variable
	int paracnt; // this stores the number of arguments
	int typelist[10]; //this stores the data type of parameters in numbers for checking
	struct symtbl *next;
};

typedef struct symtbl symtbl;
symtbl *sym_table = (symtbl *)0;
symtbl *putsym(); // will update the symbol table
symtbl *getsym(); // will return the value from symbol table
symtbl *print(); 
symtbl *update(); //used to update nest level
symtbl *updatecnt(); //used to update the number of parameteres
symtbl *updatelist(); // used to store the data type of the parameters
int isCntValid(); // whether the parameter count and its datatype

int isCntValid(char *name,int cnt,int templist[10])
{
//name is the functions name
//cnt is the number of arguments it is passing
//templist stores the datatype of the arguments in number format
  symtbl *ptr;  
  for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
   if(strcmp(ptr->name,name)==0 && ptr->proDef==1) //proDef is the bool value of procedure
    if(ptr->paracnt==cnt) //check wether the argumenrts are equal or not
     { 
     for(int i=0;i<cnt;i++)
     {
      if(ptr->typelist[i]!=templist[i] && !((ptr->typelist[i]==3&&templist[i]==4)||(ptr->typelist[i]==4&&templist[i]==3))) //this extra condition when int argument is passed to float then it should accept and vice versa
        {
         return -2;        
        }
     }
     
     return 1;
    }
    else if(ptr->paracnt>cnt)
      return 0;
    else
      return -1;
 //check yacc file for knowing what the return type does.
}


symtbl *updatecnt(char *name,int func_no,int Oparacnt,int templist[10])
{
//Oparacount is the original parameteres count
 symtbl *ptr;
	for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
	 if(ptr->func_no==func_no && ptr->proDef==1)
     {	
     ptr->paracnt=Oparacnt;
    
     strcpy(ptr->list,"");
     for(int i=0;i<Oparacnt;i++)
     { 
     ptr->typelist[i]=templist[i];
       switch(templist[i])
       {
        case 1:
             strcat(ptr->list,"void, ");
             break;
        case 2:
             strcat(ptr->list,"char, ");
             break;
        case 3:
             strcat(ptr->list,"int, ");           
             break;
        case 4:
             strcat(ptr->list,"float, ");
             break;
       }
     }
  }
}

symtbl *print()
{
 symtbl *ptr;
 FILE *f;
  f=fopen("output1.txt","w");
 fprintf(f,"Lexeme\tType\tArrayDim  Procedure Definition  nesting level  Belongs to Func  Parameters list \n");
                  fprintf(f,"----------------------------------------------------------------------------------\n");
	for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
	{ printf("%s \t%s \t%s \t\t%d \t\t\t%d\t\t%d\t\t%s\n",ptr->name,ptr->type,ptr->arrDim,ptr->proDef,ptr->nestingLevel,ptr->func_no,ptr->list);
	fprintf(f,"%s \t\t\t\t%s \t%s \t\t%d \t\t\t%d\t\t%d\t\t%s\n",ptr->name,ptr->type,ptr->arrDim,ptr->proDef,ptr->nestingLevel,ptr->func_no,ptr->list);
	 }
}

symtbl *update(int nestlvl)
{
symtbl *ptr;
 for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
   if(ptr->nestingLevel==nestlvl)
     ptr->scope_complete=1;
}

symtbl *putsym(char *sym_name,int sym_type,char *arrDim, char *list,int proDef, int nestlvl,int isArr,int func_no,int func_arg)
{
	char type[10];
	switch(sym_type)
	{
		case 1:
			strcpy(type,"void");
			break;
		case 2:
			strcpy(type,"char");
			break;
		case 3:
			strcpy(type,"int");
			break;
		case 4:
			strcpy(type,"float");
			break;
	}
	symtbl *ptr;
	ptr=(symtbl *)malloc(sizeof(symtbl));
	ptr->name=(char *)malloc(strlen(sym_name)+1);
	strcpy(ptr->name,sym_name);
	strcpy(ptr->type,type);
    strcpy(ptr->arrDim,arrDim);
    strcpy(ptr->list,list);
    ptr->nestingLevel=nestlvl;
    ptr->proDef=proDef;
    ptr->isArr=isArr;
    ptr->func_no=func_no;
    ptr->paracnt=func_arg;
    ptr->scope_complete=0;
    ptr->paracnt=0;
	ptr->next=(struct symtbl *)sym_table;
	sym_table=ptr;
	return ptr;
}

symtbl *getsym(char *sym_name,int nestlvl,int func_no,int funcCall)
{
	symtbl *ptr;
    if(funcCall==1)
    {
    for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
     if(strcmp(ptr->name,sym_name)==0 && ptr->proDef == 1)
      return ptr;
    }
   else
	for(ptr=sym_table;ptr!=(symtbl *)0;ptr=(symtbl *)ptr->next)
	 if(strcmp(ptr->name,sym_name)==0 && nestlvl>=ptr->nestingLevel && ptr->func_no==func_no && ptr->scope_complete!=1)
	return ptr;
return 0;
}
