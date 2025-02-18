
--module grammer
{ 
module Grammar where 
import Tokens 
}

--we are using posn wrapper so need to account for it
%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token 
    let { TokenLet _ } 
    in  { TokenIn _ } 
    int { TokenInt _ $$ } 
    var { TokenVar _ $$ } 
    '=' { TokenEq _ } 
    '+' { TokenPlus _ } 
    '-' { TokenMinus _ } 
    '*' { TokenTimes _ } 
    '/' { TokenDiv _ } 
    '**' { TokenExp _ }
    '(' { TokenLParen _ } 
    ')' { TokenRParen _ } 

--parser declations
%right in 
%left '+' '-' --precedence of these operators
%left '*' '/' 
%left '**'
%left NEG 
%% --dollar signs are positional components. They seem to work not on strings but the lexed expression
Exp : let var '=' Exp in Exp { Let $2 $4 $6 } 
    | Exp '+' Exp            { Plus $1 $3 } 
    | Exp '-' Exp            { Minus $1 $3 } 
    | Exp '**' Exp           { Exponent $1 $3 } 
    | Exp '*' Exp            { Times $1 $3 } 
    | Exp '/' Exp            { Div $1 $3 }
    | '(' Exp ')'            { $2 } 
    | '-' Exp %prec NEG      { Negate $2 } 
    | int                    { Int $1 } 
    | var                    { Var $1 } 
    
{ 
parseError :: [Token] -> a
parseError _ = error "Parse error" 
data Exp = Let String Exp Exp 
         | Plus Exp Exp 
         | Minus Exp Exp 
         | Times Exp Exp 
         | Div Exp Exp 
         | Exponent Exp Exp
         | Negate Exp
         | Int Int 
         | Var String 
         deriving Show 
} 