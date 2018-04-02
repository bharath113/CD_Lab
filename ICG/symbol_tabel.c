
struct symbol_table
{
	char *name;
	char type[100];
	char arrDim[100];
	char list[200];
	int proDef;
	int nestingLevel;
	int is_array;
	int func_no;
	int scope_complete;
	int parameters_count;
	int typelist[100];
	struct symbol_table *next;
};

typedef struct symbol_table symbol_table;
symbol_table *sym_table = NULL;
symbol_table *insert_symbol();
symbol_table *get_symbol();
symbol_table *print_symbol_table();
symbol_table *update_scope();
symbol_table *update_parameters();
symbol_table *update_datatypes();
int argscnt();

int argscnt(char *name,int cnt,int templist[10])
{
  symbol_table *ptr;  int i;
  for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
   if(strcmp(ptr->name,name)==0 && ptr->proDef==1)
    if(ptr->parameters_count==cnt)
     {
     for(i=0;i<cnt;i++)
     {
      if(ptr->typelist[i]!=templist[i] && !((ptr->typelist[i]==3&&templist[i]==4)||(ptr->typelist[i]==4&&templist[i]==3))) //this extra condition when int argument is passed to float then it should accept and vice versa
        {
         return -2;
        }
     }

     return 1;
    }
    else if(ptr->parameters_count>cnt)
      return 0;
    else
      return -1;
}


symbol_table *update_parameters(char *name,int func_no,int Oparameters_count,int templist[10])
{
 symbol_table *ptr;
	for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
	 if(ptr->func_no==func_no && ptr->proDef==1)
     {
     ptr->parameters_count=Oparameters_count;
    int i;
     strcpy(ptr->list,"");
     for(i=0;i<Oparameters_count;i++)
     {
     ptr->typelist[i]=templist[i];
       switch(templist[i])
       {
        case 1:
			if(i!=Oparameters_count-1)
             strcat(ptr->list,"void,");
		    else
             strcat(ptr->list,"void");
             break;
        case 2:
             if(i!=Oparameters_count-1)
             strcat(ptr->list,"char,");
		    else
             strcat(ptr->list,"char");
             break;
        case 3:
             if(i!=Oparameters_count-1)
             strcat(ptr->list,"int,");
		    else
             strcat(ptr->list,"int");
             break;
        case 4:
            if(i!=Oparameters_count-1)
             strcat(ptr->list,"float,");
		    else
             strcat(ptr->list,"float");
             break;
       }
     }
  }
}

symbol_table *print_symbol_table()
{
 symbol_table *ptr;
 FILE *f;
 char *tmp;
  f=fopen("output.txt","w");
 fprintf(f,"Lexeme\tType\tArrayDim  Procedure Definition  Parameters list  nesting level  Belongs to Func \n");
                  fprintf(f,"----------------------------------------------------------------------------------\n");
	for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
	{
		if(ptr->proDef==0)
			tmp="0";
		else
			tmp="1";
		printf("%s \t%s \t%s \t\t%s \t\t\t%d\t\t%d\t\t%s\n",ptr->name,ptr->type,ptr->arrDim,tmp,ptr->nestingLevel,ptr->func_no,ptr->list);
	fprintf(f,"%s \t\t\t\t%s \t%s \t\t%s \t\t\t%s\t\t%d\t\t%d\n",ptr->name,ptr->type,ptr->arrDim,tmp,ptr->list,ptr->nestingLevel,ptr->func_no);
	 }
}

symbol_table *update_scope(int nestlevel)
{
symbol_table *ptr;
 for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
   if(ptr->nestingLevel==nestlevel)
     ptr->scope_complete=1;
}

symbol_table *insert_symbol(char *sym_name,int sym_type,char *arrDim, char *list,int proDef, int nestlvl,int is_array,int func_no,int func_arg)
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
	symbol_table *ptr;
	ptr=(symbol_table *)malloc(sizeof(symbol_table));
	ptr->name=(char *)malloc(strlen(sym_name)+1);
	strcpy(ptr->name,sym_name);
	strcpy(ptr->type,type);
    strcpy(ptr->arrDim,arrDim);
    strcpy(ptr->list,"NA");
    ptr->nestingLevel=nestlvl;
    ptr->proDef=proDef;
    ptr->is_array=is_array;
    ptr->func_no=func_no;
    ptr->parameters_count=func_arg;
    ptr->scope_complete=0;
    ptr->parameters_count=0;
	ptr->next=(struct symbol_table *)sym_table;
	sym_table=ptr;
	return ptr;
}

symbol_table *get_symbol(char *sym_name,int nestlvl,int func_no,int funcCall)
{
	symbol_table *ptr;
    if(funcCall==1)
    {
    for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
     if(strcmp(ptr->name,sym_name)==0 && ptr->proDef == 1)
      return ptr;
    }
   else
	for(ptr=sym_table;ptr!=NULL;ptr=ptr->next)
	 if(strcmp(ptr->name,sym_name)==0 && nestlvl>=ptr->nestingLevel && ptr->func_no==func_no && ptr->scope_complete!=1)
	return ptr;
return 0;
}
 



