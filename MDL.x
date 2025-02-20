{
    module MDL where
}

%wrapper "basic"
$digit = 0-9     
$alpha = [a-zA-Z]    
$white = [ \t\n\r ]  -- Skip spaces, tabs, newlines, and carriage returns

tokens :-
  $white+ ;
  "--".* ;
  ';'           {\s -> TokenChain} --read a chain
  Forward       {\s -> TokenForward} --read a forwad move
  Back          {\s -> TokenBack} --read a back move
  RotateLeft    {\s -> TokenRotateLeft}
  RotateRight   {\s -> TokenRotateRight}
  if            {\s -> TokenIf}
  else          {\s -> TokenElse}
  then          {\s -> TokenThen}
  end           {\s -> TokenEnd}
  check         {\s -> TokenCheck}
  $digit+       {\s -> TokenInt (read s) }  --digits

{
data Token = 
  TokenInt Int |
  TokenForward  |
  TokenBack  |
  TokenRotateLeft |
  TokenRotateRight |
  TokenIf |
  TokenElse |
  TokenThen |
  TokenEnd |
  TokenChain |
  TokenCheck 
  deriving (Eq,Show)
}