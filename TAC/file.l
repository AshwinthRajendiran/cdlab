%{
#include "y.tab.h"
%}

%%

[a-zA-Z]        { yylval.sym = yytext[0]; return LETTER; }
[0-9]           { yylval.sym = yytext[0]; return NUMBER; }
[=]             { return '='; }
[+]             { return '+'; }
[-]             { return '-'; }
[*]             { return '*'; }
[/]             { return '/'; }
[()]            { return yytext[0]; }
[;]             { return ';'; }
[ \t\n]+        ;  // Ignore whitespace
.               { return yytext[0]; }

%%

