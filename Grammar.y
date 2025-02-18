
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
    let { TokenLet p } 
    in  { TokenIn p } 
    int { TokenInt p $$ } 
    var { TokenVar p $$ } 
    '=' { TokenEq p } 
    '+' { TokenPlus p } 
    '-' { TokenMinus p } 
    '*' { TokenTimes p } 
    '/' { TokenDiv p } 
    '**' { TokenExp p }
    '(' { TokenLParen p } 
    ')' { TokenRParen p } 

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
--error message
parseError :: [Token] -> a
parseError xs = error $  "Error with: " ++ show (head xs) ++ " full list of tokens is: " ++  (foldl (++) "\n" $ map (\x -> show x ++ "\n") xs)

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