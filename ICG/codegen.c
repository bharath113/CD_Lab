
#include<string.h>
#include<stdio.h>
#include<stdlib.h>

extern int nestlvl;
extern int func_no;
extern int funcCall;
extern int whilecame,ifcame,only_if,forfor;

struct stac
{
char sta[100];
int add;
int nestl;
int funcl;
int updated;
char ope[10];
struct stac*left;
struct stac*right;
};

void icgif(struct stac*);
void icgwhile(struct stac*d);
void onlyfor(struct stac*);
void onlyif(struct stac*);
void labelforwhile();
void labelforend();
void labelforin();
void gotoforincre();
void labelforincrement();
void createfun(char *);
void labelforonlyif();
void afteronlyif();


int while_cnt=0;
int z;
int ifelse_cnt=0;
int y;
int x=0,g;
int h;
int whilopen[100];
char wopen[100][100];
char ifafter[100][100];
char ifonly[100][100];
char forin[100];
char ifelse[100][100];
char forend[100][100];
char forincre[100];
int adds=100;
int fortp=0;
int n=0;
int forstart;
int increstart[100];
int f=0;
struct stac *stack_list[100];

struct stac *extra_stac[10000];
int extra_cnt=0;

int stac_count=0;

void reverse(char str[], int len)
{
    int start, end;
    char temp;
    for(start=0, end=len-1; start < end; start++, end--) {
        temp = *(str+start);
        *(str+start) = *(str+end);
        *(str+end) = temp;
    }
}

char* itoa(int num, char* str, int base)
{
    int i = 0;
    int isNegative = 0;
 
  
    if (num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }

    if (num < 0 && base == 10)
    {
        isNegative = 1;
        num = -num;
    }
 

    while (num != 0)
    {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }

    if (isNegative)
        str[i++] = '-';
 
    str[i] = '\0'; 
 
    reverse(str, i);
 
    return str;
}



void putin(char s[100])
{
struct stac *temp,*temp1,*pk;
temp= (struct stac*)malloc(sizeof(struct stac));
strcpy(temp->ope,"@");
strcpy(temp->sta,s);
temp->left=NULL;
temp->right=NULL;
temp->updated=0;
symbol_table *d;	
	d = take_symbol(temp->sta,nestlvl,func_no,funcCall);
	if(d!=NULL)
	{
	temp->nestl=d->nestingLevel;
	temp->funcl=d->func_no;
	}
stack_list[stac_count++]=temp;

}

void create_tree(int k)
{
struct stac* tmp,*pk;
char var[10];
char c[100];
char d[100]="T";
itoa(n,c,10);
strcat(d,c);
if(k==0)
strcpy(var,"=");
else if(k==1)
strcpy(var,"+");
else if(k==2)
strcpy(var,"-");
else if(k==3)
strcpy(var,"*");
else if(k==4)
strcpy(var,"/");
else if(k==5)
strcpy(var,"<");
else if(k==6)
strcpy(var,">");
else if(k==7)
strcpy(var,"<=");
else if(k==8)
strcpy(var,"<=");
else if(k==9)
strcpy(var,"==");
else if(k==10)
strcpy(var,"!=");

if(k!=0)
	n++;

tmp=(struct stac*)malloc(sizeof(struct stac));
tmp->right=stack_list[--stac_count];
tmp->left=stack_list[--stac_count];
stack_list[stac_count++]=tmp;
strcpy(tmp->ope,var);
strcpy(tmp->sta,d);
	tmp->add=adds;
	adds++;

if(k!=0)
	{
printf("\t%d : %s = %s %s %s\n",tmp->add,tmp->sta,tmp->left->sta,var,tmp->right->sta);
	if(k>=5)
	{
		if(whilecame==1&&ifcame==0&&only_if==0&&forfor==0)
	        icgwhile(tmp);
		else if(whilecame==0&&ifcame==1&&only_if==0&&forfor==0)
			icgif(tmp);
		else if(whilecame==0&&ifcame==0&&only_if==1&&forfor==0)
			onlyif(tmp);
		else if(whilecame==0&&ifcame==0&&forfor==1&&only_if==0)
			onlyfor(tmp);
	}
	}
else
printf("\t%d : %s %s %s\n",tmp->add,tmp->left->sta,var,tmp->right->sta);
}

void icgwhile(struct stac*d)
{
	whilopen[z]=adds++;
    printf("\t%d : IF NOT %s GOTO %s\n",whilopen[z],d->sta,wopen[z]);
}

void labelforwhile()
{
	z=while_cnt++;
	char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(wopen[z],b);
}

void creategoto()
{
	z=--while_cnt;
	printf("\tGOTO %d\n",whilopen[z]-1);
	printf("    %s: \n",wopen[z]);
}



void labelforifelse()
{
	y=ifelse_cnt++;
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(ifelse[y],b);
}

void icgif(struct stac*d)
{
labelforifelse();
printf("\t%d : IF NOT %s GOTO %s\n",adds++,d->sta,ifelse[y]);
}

void creategotoif()
{
	y=--ifelse_cnt;
	g=x-1;
	printf("\tGOTO %s\n",ifafter[g]);
	printf("    %s : \n",ifelse[y]);
}

void afterif()
{
	printf("    %s: \n",ifafter[--x]);
}

void labelforifafter()
{
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(ifafter[x],b);
	x++;
}



void onlyif(struct stac*d)
{
labelforonlyif();
printf("\t%d : IF NOT %s GOTO %s\n",adds++,d->sta,ifonly[y]);
}

void afteronlyif()
{
	if(strcmp(ifonly[y],"")==0)
	{
		strcpy(ifonly[y],ifelse[y]);
	}
  printf("    %s : \n",ifonly[y]);
  strcpy(ifonly[y],"");
  y--;
  ifelse_cnt--;
}

void labelforonlyif()
{
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(ifonly[y],b);
}

void createfun(char *s)
{
printf("\tCALL  %s\n",s);
}



void onlyfor(struct stac*d)
{
forstart=adds;
labelforend();
printf("\t%d : IF NOT %s GOTO %s\n",adds++,d->sta,forend[h]);
labelforin();
printf("\tGOTO %s\n",forin);
labelforincrement();
printf("    %s: \n",forincre);
}

void labelforin()
{
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(forin,b);
}

void labelforend()
{
    h=fortp++;
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(forend[h],b);
}


void labelforincrement()
{
    char c[100];
	char b[100];
	strcpy(b,"L");
    itoa(f,c,10);
	f++;
	strcat(b,c);
	strcpy(forincre,b);
}

void gotoforstart()
{
	increstart[h]=adds;
	printf("\tGOTO %d \n",forstart-1);
	printf("    %s:\n",forin);
}

void gotoforincre()
{
printf("\tGOTO %d \n",increstart[h]-2);
printf("    %s:\n",forend[h]);
h--;
}
