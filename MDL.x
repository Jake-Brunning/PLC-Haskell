{
    module MDL where
}

%wrapper "basic"
$digit = 0-9     
$alpha = [a-zA-Z]    


tokens :-
$white+ ;
  "--".* ;
  forward {\s -> TokenForward (read s)} --read a forwad move
  back {\s -> TokenBack (read s)} --read a back move
  RotateLeft {\s -> TokenRotateLeft}
  RotateRight {\s -> TokenRotateRight}
  if {\s -> TokenIf}
  else {\s -> TokenElse}
  then {\s -> TokenThen}
  end {\s -> TokenEnd}
  check {\s -> TokenCheck (read s)}

{
data Token = 
  TokenForward Int |
  TokenBack Int |
  TokenRotateLeft |
  TokenRotateRight |
  TokenIf |
  TokenElse |
  TokenThen |
  TokenEnd |
  TokenCheck Int
  deriving (Eq,Show)
}