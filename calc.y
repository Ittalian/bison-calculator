/* Very simple grammar  */

%{
/* includes and definitions go here */
#include <stdio.h>
#include <stdlib.h>

/* type of semantic value, int is default */
#define YYSTYPE double

/* set to 1 for debugging, otherwise to 0 */
#define YYDEBUG 0

/* yylex function, returns token type */
int yylex (void);

/* error function, called when error is detected */
void yyerror (char const *);
%}
     
%token NUM PLUS HYPHEN ASTERISK SLASH
%token SEMICOLON OPENPAREN CLOSEPAREN

%%
/* Grammar rules and actions  */

statement_list:   statement {}
                | statement statement_list {}
;
statement: exp SEMICOLON   { printf ("Result is %g\n", $1); }
         | error SEMICOLON { yyerror("Statement Error!\n"); yyerrok; }
;

exp:      exp PLUS term { $$ = $1 + $3; }
        | exp HYPHEN term { $$ = $1 - $3; }
        | term          { $$ = $1; }
;

term:     term ASTERISK factor { $$ = $1 * $3; }
        | term SLASH factor { $$ = $1 / $3; }
        | factor { $$ = $1; }
;

factor:   OPENPAREN term CLOSEPAREN { $$ = $2; }
        | NUM { $$ = $1; } 
;

%%

int main (void)
{
#if YYDEBUG != 0
    yydebug = YYDEBUG; /* for debugging */
#endif
    return yyparse ();
}
     
     
/* Called by yyparse on error.  */
void yyerror (char const *s)
{
     fprintf (stderr, "%s\n", s);
}

