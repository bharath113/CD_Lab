%option noyywrap
%{
 #include"exp.tab.h"s
 int yylineno=1;
%}
datatype "int"|"float"|"char"|"long"
alpha [a-zA-Z]
digit [0-9]
header "#include<"
had  ".h>"
noperators ">="|"<="|"=="|">"|"<"|"!="|"-="|"+="|"*="|"/="
coperators "&&"|"||"
unary     "++"|"--"
dot [.]
decimal {digit}{digit}*{dot}{digit}{digit}*
sign [-+]
negnum {sign}{digit}+
%%
[\t ]
[\n] {yylineno++;}
{noperators}      {return OP;}
{coperators}       {return COP;}
{unary}            {return UN;}
{header}(.)*{had} {return HEAD;}
while             {return WHILE;}
for               {return FOR;} 
if		  {return IF;}
else              {return ELSE;} 
break             {return BREAK;} 
return           {return RETURN;}
{datatype}         {return TYPE;}
main        {return ID;}
({digit}+|{decimal}|{negnum})    {return NUM;}
{alpha}({alpha}|{digit})* {return ID;}

.                return yytext[0];
%%